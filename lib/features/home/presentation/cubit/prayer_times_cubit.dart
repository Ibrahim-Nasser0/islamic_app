import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../domain/repositories/prayer_repository.dart';
import 'prayer_times_state.dart';

/// Cubit managing prayer times calculation and real-time second-by-second countdown
class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerRepository _repository;
  Timer? _timer;
  double? _currentLat;
  double? _currentLng;
  String? _currentNameAr;
  String? _currentNameEn;

  PrayerTimesCubit(this._repository) : super(PrayerTimesInitial());

  Future<void> loadPrayerTimes() async {
    emit(PrayerTimesLoading());
    try {
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
      ));

      _startTimer();

      // Detect real GPS in background if not already resolved
      _fetchRealLocationInBackground();
    } catch (e) {
      emit(PrayerTimesError(e.toString()));
    }
  }

  Future<void> refreshLocation() async {
    try {
      final loc = await _repository.detectCurrentLocation();
      _currentLat = loc.latitude;
      _currentLng = loc.longitude;
      _currentNameAr = loc.nameAr;
      _currentNameEn = loc.nameEn;
      await loadPrayerTimes();
    } catch (_) {
      // Fallback stays
    }
  }

  void _fetchRealLocationInBackground() {
    _repository.detectCurrentLocation().then((loc) {
      if (isClosed) return;
      if (loc.latitude != _currentLat ||
          loc.longitude != _currentLng ||
          loc.nameAr != _currentNameAr) {
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

      final newDuration = currentState.remainingDuration - const Duration(seconds: 1);

      if (newDuration.inSeconds <= 0) {
        // Prayer time reached! Recompute schedule immediately
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
