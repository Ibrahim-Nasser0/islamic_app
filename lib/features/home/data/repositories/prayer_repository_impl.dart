import '../../../../core/services/location_preference_service.dart';
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
  Future<LocationAcquireResult> detectCurrentLocation({
    bool requestPermission = true,
  }) async {
    final isManual = await LocationPreferenceService.isManual();
    if (isManual) {
      final saved = await LocationPreferenceService.getFastCachedActiveLocation();
      return (
        latitude: saved.latitude,
        longitude: saved.longitude,
        nameAr: saved.nameAr,
        nameEn: saved.nameEn,
        status: LocationAcquireStatus.cachedFallback,
      );
    }
    return locationService.acquireLocation(requestPermission: requestPermission);
  }

  @override
  Future<DailyPrayerSchedule> getDailyPrayerSchedule({
    double? latitude,
    double? longitude,
    String? nameAr,
    String? nameEn,
    DateTime? date,
  }) async {
    double lat;
    double lng;
    String locAr;
    String locEn;

    if (latitude != null && longitude != null) {
      lat = latitude;
      lng = longitude;
      locAr = nameAr ?? LocationService.defaultCairoAr;
      locEn = nameEn ?? LocationService.defaultCairoEn;
    } else {
      final cached = await LocationPreferenceService.getFastCachedActiveLocation();
      lat = cached.latitude;
      lng = cached.longitude;
      locAr = cached.nameAr;
      locEn = cached.nameEn;
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
