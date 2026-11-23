import 'package:equatable/equatable.dart';
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

  const PrayerTimesLoaded({
    required this.schedule,
    required this.remainingDuration,
    required this.formattedRemainingTime,
    this.tick = 0,
  });

  PrayerTimesLoaded copyWith({
    DailyPrayerSchedule? schedule,
    Duration? remainingDuration,
    String? formattedRemainingTime,
    int? tick,
  }) {
    return PrayerTimesLoaded(
      schedule: schedule ?? this.schedule,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      formattedRemainingTime:
          formattedRemainingTime ?? this.formattedRemainingTime,
      tick: tick ?? this.tick,
    );
  }

  @override
  List<Object?> get props => [
        schedule,
        remainingDuration,
        formattedRemainingTime,
        tick,
      ];
}

class PrayerTimesError extends PrayerTimesState {
  final String message;

  const PrayerTimesError(this.message);

  @override
  List<Object?> get props => [message];
}
