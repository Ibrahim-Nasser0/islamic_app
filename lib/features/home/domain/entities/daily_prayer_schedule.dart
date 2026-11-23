import 'package:equatable/equatable.dart';
import 'prayer_time_entry.dart';

/// Full Daily Prayer Schedule with metadata
class DailyPrayerSchedule extends Equatable {
  final List<PrayerTimeEntry> prayers;
  final PrayerTimeEntry? currentPrayer;
  final PrayerTimeEntry nextPrayer;
  final Duration timeToNextPrayer;
  final String locationName;
  final String hijriDate;
  final String gregorianDate;
  final double latitude;
  final double longitude;

  const DailyPrayerSchedule({
    required this.prayers,
    this.currentPrayer,
    required this.nextPrayer,
    required this.timeToNextPrayer,
    required this.locationName,
    required this.hijriDate,
    required this.gregorianDate,
    required this.latitude,
    required this.longitude,
  });

  DailyPrayerSchedule copyWith({
    List<PrayerTimeEntry>? prayers,
    PrayerTimeEntry? currentPrayer,
    PrayerTimeEntry? nextPrayer,
    Duration? timeToNextPrayer,
    String? locationName,
    String? hijriDate,
    String? gregorianDate,
    double? latitude,
    double? longitude,
  }) {
    return DailyPrayerSchedule(
      prayers: prayers ?? this.prayers,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeToNextPrayer: timeToNextPrayer ?? this.timeToNextPrayer,
      locationName: locationName ?? this.locationName,
      hijriDate: hijriDate ?? this.hijriDate,
      gregorianDate: gregorianDate ?? this.gregorianDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        prayers,
        currentPrayer,
        nextPrayer,
        timeToNextPrayer,
        locationName,
        hijriDate,
        gregorianDate,
        latitude,
        longitude,
      ];
}
