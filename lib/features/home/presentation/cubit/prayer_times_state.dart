import 'package:equatable/equatable.dart';
import '../../data/datasources/location_service.dart';
import '../../domain/entities/daily_prayer_schedule.dart';

abstract class PrayerTimesState extends Equatable {
  const PrayerTimesState();

  @override
  List<Object?> get props => [];
}

class PrayerTimesInitial extends PrayerTimesState {}

class PrayerTimesLoading extends PrayerTimesState {}

class PrayerTimesLoaded extends PrayerTimesState {
  final DailyPrayerSchedule schedule;
  final Duration remainingDuration;
  final String formattedRemainingTime;
  final int tick;
  final bool isRefreshingLocation;
  final bool isManualLocation;
  final LocationAcquireStatus? lastLocationStatus;

  const PrayerTimesLoaded({
    required this.schedule,
    required this.remainingDuration,
    required this.formattedRemainingTime,
    this.tick = 0,
    this.isRefreshingLocation = false,
    this.isManualLocation = false,
    this.lastLocationStatus,
  });

  /// Elapsed fraction [0.0..1.0] between current/previous prayer and next prayer.
  double get intervalProgress {
    final prev = schedule.currentPrayer;
    final next = schedule.nextPrayer;
    if (prev == null) return 0.5;
    final total = next.time.difference(prev.time).inSeconds;
    if (total <= 0) return 0.0;
    final elapsed = total - remainingDuration.inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  PrayerTimesLoaded copyWith({
    DailyPrayerSchedule? schedule,
    Duration? remainingDuration,
    String? formattedRemainingTime,
    int? tick,
    bool? isRefreshingLocation,
    bool? isManualLocation,
    LocationAcquireStatus? lastLocationStatus,
  }) {
    return PrayerTimesLoaded(
      schedule: schedule ?? this.schedule,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      formattedRemainingTime:
          formattedRemainingTime ?? this.formattedRemainingTime,
      tick: tick ?? this.tick,
      isRefreshingLocation: isRefreshingLocation ?? this.isRefreshingLocation,
      isManualLocation: isManualLocation ?? this.isManualLocation,
      lastLocationStatus: lastLocationStatus ?? this.lastLocationStatus,
    );
  }

  @override
  List<Object?> get props => [
        schedule,
        remainingDuration,
        formattedRemainingTime,
        tick,
        isRefreshingLocation,
        isManualLocation,
        lastLocationStatus,
      ];
}

class PrayerTimesError extends PrayerTimesState {
  final String message;

  const PrayerTimesError(this.message);

  @override
  List<Object?> get props => [message];
}
