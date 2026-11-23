import '../entities/daily_prayer_schedule.dart';

/// Contract for Prayer Times repository
abstract class PrayerRepository {
  /// Computes and returns the complete prayer schedule for a given date and coordinates
  Future<DailyPrayerSchedule> getDailyPrayerSchedule({
    double? latitude,
    double? longitude,
    String? locationName,
    DateTime? date,
  });

  /// Detects user's real GPS coordinates with graceful fallback to default city
  Future<({double latitude, double longitude, String locationName})>
      detectCurrentLocation();
}
