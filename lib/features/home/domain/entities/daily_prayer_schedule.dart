import 'package:equatable/equatable.dart';
import 'prayer_time_entry.dart';

/// Full Daily Prayer Schedule with metadata
class DailyPrayerSchedule extends Equatable {
  final List<PrayerTimeEntry> prayers;
  final PrayerTimeEntry? currentPrayer;
  final PrayerTimeEntry nextPrayer;
  final Duration timeToNextPrayer;
  final String locationNameAr;
  final String locationNameEn;
  final String hijriDateAr;
  final String hijriDateEn;
  final DateTime date;
  final double latitude;
  final double longitude;

  const DailyPrayerSchedule({
    required this.prayers,
    this.currentPrayer,
    required this.nextPrayer,
    required this.timeToNextPrayer,
    required this.locationNameAr,
    required this.locationNameEn,
    required this.hijriDateAr,
    required this.hijriDateEn,
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  String getLocalizedLocation(String langCode) =>
      langCode == 'ar' ? locationNameAr : locationNameEn;

  String getHijriDate(String langCode) =>
      langCode == 'ar' ? hijriDateAr : hijriDateEn;

  DailyPrayerSchedule copyWith({
    List<PrayerTimeEntry>? prayers,
    PrayerTimeEntry? currentPrayer,
    PrayerTimeEntry? nextPrayer,
    Duration? timeToNextPrayer,
    String? locationNameAr,
    String? locationNameEn,
    String? hijriDateAr,
    String? hijriDateEn,
    DateTime? date,
    double? latitude,
    double? longitude,
  }) {
    return DailyPrayerSchedule(
      prayers: prayers ?? this.prayers,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeToNextPrayer: timeToNextPrayer ?? this.timeToNextPrayer,
      locationNameAr: locationNameAr ?? this.locationNameAr,
      locationNameEn: locationNameEn ?? this.locationNameEn,
      hijriDateAr: hijriDateAr ?? this.hijriDateAr,
      hijriDateEn: hijriDateEn ?? this.hijriDateEn,
      date: date ?? this.date,
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
        locationNameAr,
        locationNameEn,
        hijriDateAr,
        hijriDateEn,
        date,
        latitude,
        longitude,
      ];
}
