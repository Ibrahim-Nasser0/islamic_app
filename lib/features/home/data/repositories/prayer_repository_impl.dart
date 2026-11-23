import '../../domain/entities/daily_prayer_schedule.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/location_service.dart';
import '../datasources/prayer_calculation_service.dart';

/// Concrete implementation of PrayerRepository
class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerCalculationService calculationService;
  final LocationService locationService;

  PrayerRepositoryImpl({
    required this.calculationService,
    required this.locationService,
  });

  @override
  Future<({double latitude, double longitude, String nameAr, String nameEn})>
      detectCurrentLocation() {
    return locationService.getCurrentLocation();
  }

  @override
  Future<DailyPrayerSchedule> getDailyPrayerSchedule({
    double? latitude,
    double? longitude,
    String? nameAr,
    String? nameEn,
    DateTime? date,
  }) async {
    double lat = latitude ?? LocationService.defaultCairoLat;
    double lng = longitude ?? LocationService.defaultCairoLng;
    String locAr = nameAr ?? LocationService.defaultCairoAr;
    String locEn = nameEn ?? LocationService.defaultCairoEn;

    if (latitude == null || longitude == null) {
      final loc = await locationService.getCurrentLocation();
      lat = loc.latitude;
      lng = loc.longitude;
      locAr = loc.nameAr;
      locEn = loc.nameEn;
    }

    return calculationService.calculateSchedule(
      latitude: lat,
      longitude: lng,
      locationNameAr: locAr,
      locationNameEn: locEn,
      targetDate: date,
    );
  }
}
