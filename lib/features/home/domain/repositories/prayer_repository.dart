import '../../data/datasources/location_service.dart';
import '../entities/daily_prayer_schedule.dart';

/// Contract for Prayer Times repository
abstract class PrayerRepository {
  /// Computes and returns the complete prayer schedule for a given date and coordinates.
  Future<DailyPrayerSchedule> getDailyPrayerSchedule({
    double? latitude,
    double? longitude,
    String? nameAr,
    String? nameEn,
    DateTime? date,
  });

  /// Detects user's live GPS coordinates with multi-stage caching & status reporting.
  Future<LocationAcquireResult> detectCurrentLocation({
    bool requestPermission = true,
  });
}
