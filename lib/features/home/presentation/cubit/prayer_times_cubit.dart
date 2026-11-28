import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/location_preference_service.dart';
import '../../../../core/services/notification/prayer_alarm_scheduler.dart';
import '../../../settings/data/datasources/settings_local_data_source.dart';
import '../../data/datasources/location_service.dart';
import '../../domain/repositories/prayer_repository.dart';
import 'prayer_times_state.dart';

/// Cubit managing prayer times calculation, instant cached startup, and GPS refresh.
class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerRepository _repository;
  final PrayerAlarmScheduler? _alarmScheduler;
  final SettingsLocalDataSource? _settingsDs;
  Timer? _timer;
  double? _currentLat;
  double? _currentLng;
  String? _currentNameAr;
  String? _currentNameEn;
  bool _isManual = false;
  bool _hasAttemptedBgLocation = false;
  String? _lastScheduledCoords;

  PrayerTimesCubit(
    this._repository, {
    PrayerAlarmScheduler? alarmScheduler,
    SettingsLocalDataSource? settingsDs,
  })  : _alarmScheduler = alarmScheduler,
        _settingsDs = settingsDs,
        super(PrayerTimesInitial());

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
      _syncAlarmsIfLocationChanged(schedule.latitude, schedule.longitude);

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
    } catch (e, stackTrace) {
      debugPrint('[PrayerTimesCubit] refreshLocation failed: $e\n$stackTrace');
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
    }).catchError((Object e) {
      debugPrint('[PrayerTimesCubit] bg location failed: $e');
    });
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

  void _syncAlarmsIfLocationChanged(double lat, double lng) {
    final scheduler = _alarmScheduler;
    final ds = _settingsDs;
    if (scheduler == null || ds == null) return;
    final key = '${lat.toStringAsFixed(3)},${lng.toStringAsFixed(3)}';
    if (_lastScheduledCoords == key) return;
    _lastScheduledCoords = key;
    unawaited(
      scheduler.schedulePrayerAlarms(
        latitude: lat,
        longitude: lng,
        adhanEnabled: ds.getPrayerNotification() && ds.getAthanSound(),
        preAlertEnabled: ds.getPrayerNotification() && ds.getPrePrayerNotification(),
        cityAr: _currentNameAr,
        cityEn: _currentNameEn,
      ).catchError((Object e) {
        debugPrint('[PrayerTimesCubit] Alarm reschedule failed: $e');
      }),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
