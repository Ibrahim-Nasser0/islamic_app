import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../core/services/location_preference_service.dart';
import '../../data/datasources/location_service.dart';
import '../../domain/repositories/prayer_repository.dart';
import 'prayer_times_state.dart';

/// Cubit managing prayer times calculation, instant cached startup, and GPS refresh.
class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerRepository _repository;
  Timer? _timer;
  double? _currentLat;
  double? _currentLng;
  String? _currentNameAr;
  String? _currentNameEn;
  bool _isManual = false;
  bool _hasAttemptedBgLocation = false;

  PrayerTimesCubit(this._repository) : super(PrayerTimesInitial());

  Future<void> loadPrayerTimes() async {
    if (state is! PrayerTimesLoaded) emit(PrayerTimesLoading());
    try {
      _isManual = await LocationPreferenceService.isManual();
      final schedule = await _repository.getDailyPrayerSchedule(
        latitude: _currentLat,
        longitude: _currentLng,
        nameAr: _currentNameAr,
        nameEn: _currentNameEn,
      );

      _currentLat = schedule.latitude;
      _currentLng = schedule.longitude;
      _currentNameAr = schedule.locationNameAr;
      _currentNameEn = schedule.locationNameEn;

      final remaining = schedule.timeToNextPrayer;
      emit(PrayerTimesLoaded(
        schedule: schedule,
        remainingDuration: remaining,
        formattedRemainingTime: formatCountdown(remaining),
        tick: 0,
        isManualLocation: _isManual,
      ));

      _startTimer();

      if (!_hasAttemptedBgLocation && !_isManual) {
        _hasAttemptedBgLocation = true;
        _fetchRealLocationInBackground();
      }
    } catch (e) {
      emit(PrayerTimesError(e.toString()));
    }
  }

  /// Explicitly refreshes GPS (prompts if needed) and returns outcome status.
  Future<LocationAcquireStatus> refreshLocation() async {
    final current = state;
    if (current is PrayerTimesLoaded) {
      emit(current.copyWith(isRefreshingLocation: true));
    }
    try {
      _isManual = await LocationPreferenceService.isManual();
      if (_isManual) {
        await loadPrayerTimes();
        return LocationAcquireStatus.cachedFallback;
      }
      final loc = await _repository.detectCurrentLocation(
        requestPermission: true,
      );
      if (isClosed) return loc.status;

      final changed = loc.latitude != _currentLat ||
          loc.longitude != _currentLng ||
          loc.nameAr != _currentNameAr;
      _currentLat = loc.latitude;
      _currentLng = loc.longitude;
      _currentNameAr = loc.nameAr;
      _currentNameEn = loc.nameEn;

      if (changed) {
        await loadPrayerTimes();
      } else if (state is PrayerTimesLoaded) {
        emit((state as PrayerTimesLoaded).copyWith(
          isRefreshingLocation: false,
          lastLocationStatus: loc.status,
        ));
      }
      return loc.status;
    } catch (_) {
      if (!isClosed && state is PrayerTimesLoaded) {
        emit((state as PrayerTimesLoaded).copyWith(isRefreshingLocation: false));
      }
      return LocationAcquireStatus.timeout;
    }
  }

  void _fetchRealLocationInBackground() {
    _repository.detectCurrentLocation(requestPermission: false).then((loc) {
      if (isClosed) return;
      final changed = loc.latitude != _currentLat ||
          loc.longitude != _currentLng ||
          loc.nameAr != _currentNameAr;
      if (changed &&
          (loc.status == LocationAcquireStatus.gpsSuccess ||
              loc.status == LocationAcquireStatus.lastKnownFallback)) {
        _currentLat = loc.latitude;
        _currentLng = loc.longitude;
        _currentNameAr = loc.nameAr;
        _currentNameEn = loc.nameEn;
        loadPrayerTimes();
      }
    }).catchError((_) {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      final currentState = state;
      if (currentState is! PrayerTimesLoaded) return;

      final newDuration =
          currentState.remainingDuration - const Duration(seconds: 1);
      if (newDuration.inSeconds <= 0) {
        loadPrayerTimes();
      } else {
        emit(currentState.copyWith(
          remainingDuration: newDuration,
          formattedRemainingTime: formatCountdown(newDuration),
          tick: currentState.tick + 1,
        ));
      }
    });
  }

  static String formatCountdown(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
