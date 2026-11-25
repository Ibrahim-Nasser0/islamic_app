import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/data/datasources/location_service.dart';
import '../utils/constants.dart';

typedef SavedLocationRecord = ({
  double latitude,
  double longitude,
  String nameAr,
  String nameEn,
  bool isManual,
});

/// Manages manual location overrides and cached last-known GPS coordinates.
class LocationPreferenceService {
  static const String _lastGpsLatKey = 'last_gps_lat';
  static const String _lastGpsLngKey = 'last_gps_lng';
  static const String _lastGpsNameArKey = 'last_gps_name_ar';
  static const String _lastGpsNameEnKey = 'last_gps_name_en';

  /// Instant non-blocking read: manual city if set, else last cached GPS, else Cairo.
  static Future<SavedLocationRecord> getFastCachedActiveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final isManual = prefs.getBool(AppConstants.isManualLocationKey) ?? false;
    if (isManual) {
      return _readManual(prefs);
    }
    return getCachedGpsOrDefault(prefs: prefs);
  }

  static Future<SavedLocationRecord> getCachedGpsOrDefault({
    SharedPreferences? prefs,
  }) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    final lat = p.getDouble(_lastGpsLatKey);
    final lng = p.getDouble(_lastGpsLngKey);
    final nameAr = p.getString(_lastGpsNameArKey);
    final nameEn = p.getString(_lastGpsNameEnKey);

    if (lat != null && lng != null && nameAr != null && nameEn != null) {
      return (
        latitude: lat,
        longitude: lng,
        nameAr: nameAr,
        nameEn: nameEn,
        isManual: false,
      );
    }
    return (
      latitude: LocationService.defaultCairoLat,
      longitude: LocationService.defaultCairoLng,
      nameAr: LocationService.defaultCairoAr,
      nameEn: LocationService.defaultCairoEn,
      isManual: false,
    );
  }

  static Future<void> cacheGpsLocation({
    required double latitude,
    required double longitude,
    required String nameAr,
    required String nameEn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setDouble(_lastGpsLatKey, latitude),
      prefs.setDouble(_lastGpsLngKey, longitude),
      prefs.setString(_lastGpsNameArKey, nameAr),
      prefs.setString(_lastGpsNameEnKey, nameEn),
    ]);
  }

  static SavedLocationRecord _readManual(SharedPreferences prefs) => (
        latitude: prefs.getDouble(AppConstants.customLocationLatKey) ??
            LocationService.defaultCairoLat,
        longitude: prefs.getDouble(AppConstants.customLocationLngKey) ??
            LocationService.defaultCairoLng,
        nameAr: prefs.getString(AppConstants.customLocationNameArKey) ??
            LocationService.defaultCairoAr,
        nameEn: prefs.getString(AppConstants.customLocationNameEnKey) ??
            LocationService.defaultCairoEn,
        isManual: true,
      );

  static Future<SavedLocationRecord> getActiveLocation({
    LocationService? locationService,
    bool requestPermission = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(AppConstants.isManualLocationKey) ?? false) {
      return _readManual(prefs);
    }
    final service = locationService ?? LocationService();
    final gpsLoc = await service.acquireLocation(
      requestPermission: requestPermission,
    );
    return (
      latitude: gpsLoc.latitude,
      longitude: gpsLoc.longitude,
      nameAr: gpsLoc.nameAr,
      nameEn: gpsLoc.nameEn,
      isManual: false,
    );
  }

  static Future<void> setManualLocation({
    required double latitude,
    required double longitude,
    required String nameAr,
    required String nameEn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(AppConstants.isManualLocationKey, true),
      prefs.setDouble(AppConstants.customLocationLatKey, latitude),
      prefs.setDouble(AppConstants.customLocationLngKey, longitude),
      prefs.setString(AppConstants.customLocationNameArKey, nameAr),
      prefs.setString(AppConstants.customLocationNameEnKey, nameEn),
    ]);
  }

  static Future<void> resetToGps() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(AppConstants.isManualLocationKey, false),
      prefs.remove(AppConstants.customLocationLatKey),
      prefs.remove(AppConstants.customLocationLngKey),
      prefs.remove(AppConstants.customLocationNameArKey),
      prefs.remove(AppConstants.customLocationNameEnKey),
    ]);
  }

  static Future<bool> isManual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isManualLocationKey) ?? false;
  }
}
