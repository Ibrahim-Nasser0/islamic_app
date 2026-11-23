import 'dart:async';
import 'dart:math' as math;
import 'package:adhan/adhan.dart' as adhan;
import 'package:bloc/bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../../../core/utils/haptics.dart';
import '../../../home/data/datasources/location_service.dart';
import '../../domain/entities/qibla_data.dart';
import 'qibla_state.dart';

/// Cubit managing GPS coordinates, Qibla calculation, and real-time device heading
class QiblaCubit extends Cubit<QiblaState> {
  final LocationService _locationService;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _lastAligned = false;
  double _qiblaBearing = 0;
  double _distanceKm = 0;
  String _cityName = '';

  QiblaCubit(this._locationService) : super(QiblaInitial());

  Future<void> initQibla() async {
    emit(QiblaLoading());
    try {
      final loc = await _locationService.getCurrentLocation();
      final coordinates = adhan.Coordinates(loc.latitude, loc.longitude);
      _qiblaBearing = adhan.Qibla(coordinates).direction;
      _distanceKm = _calculateDistance(loc.latitude, loc.longitude);
      _cityName = loc.nameAr;

      final events = FlutterCompass.events;
      if (events == null) {
        emit(QiblaLoaded(
          data: QiblaData(
            qiblaDirection: _qiblaBearing,
            deviceHeading: 0,
            distanceKm: _distanceKm,
            locationName: _cityName,
            hasCompass: false,
          ),
        ));
        return;
      }

      _compassSubscription?.cancel();
      _compassSubscription = events.listen((event) {
        if (isClosed) return;
        final heading = event.heading ?? 0.0;
        final normalizedHeading = (heading + 360) % 360;

        final data = QiblaData(
          qiblaDirection: _qiblaBearing,
          deviceHeading: normalizedHeading,
          distanceKm: _distanceKm,
          locationName: _cityName,
          hasCompass: true,
        );

        if (data.isAligned && !_lastAligned) {
          AppHaptics.heavy();
        }
        _lastAligned = data.isAligned;

        emit(QiblaLoaded(data: data));
      });
    } catch (e) {
      emit(QiblaError(e.toString()));
    }
  }

  static double _calculateDistance(double lat, double lng) {
    const double r = 6371.0;
    final makkahLat = adhan.Qibla.MAKKAH.latitude;
    final makkahLng = adhan.Qibla.MAKKAH.longitude;
    final dLat = (makkahLat - lat) * (math.pi / 180.0);
    final dLng = (makkahLng - lng) * (math.pi / 180.0);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat * (math.pi / 180.0)) *
            math.cos(makkahLat * (math.pi / 180.0)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    return super.close();
  }
}
