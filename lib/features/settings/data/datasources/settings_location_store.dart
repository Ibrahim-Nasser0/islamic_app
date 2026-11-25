import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/data/datasources/location_service.dart';

/// SharedPreferences storage helpers for manual & GPS location fallback state.
typedef SavedLocationRecordFallback = ({
  double lat,
  double lng,
  String nameAr,
  String nameEn,
});

class SettingsLocationStore {
  const SettingsLocationStore._();

  static bool isManualLocation(SharedPreferences prefs) =>
      prefs.getBool(AppConstants.isManualLocationKey) ?? false;

  static SavedLocationRecordFallback? _readCachedGps(SharedPreferences prefs) {
    final lat = prefs.getDouble('last_gps_lat');
    final lng = prefs.getDouble('last_gps_lng');
    final nameAr = prefs.getString('last_gps_name_ar');
    final nameEn = prefs.getString('last_gps_name_en');
    if (lat != null && lng != null && nameAr != null && nameEn != null) {
      return (lat: lat, lng: lng, nameAr: nameAr, nameEn: nameEn);
    }
    return null;
  }

  static ({double lat, double lng, String nameAr, String nameEn, bool isManual})
      getLocation(SharedPreferences prefs) {
    final manual = isManualLocation(prefs);
    if (manual) {
      return (
        lat: prefs.getDouble(AppConstants.customLocationLatKey) ??
            LocationService.defaultCairoLat,
        lng: prefs.getDouble(AppConstants.customLocationLngKey) ??
            LocationService.defaultCairoLng,
        nameAr: prefs.getString(AppConstants.customLocationNameArKey) ??
            LocationService.defaultCairoAr,
        nameEn: prefs.getString(AppConstants.customLocationNameEnKey) ??
            LocationService.defaultCairoEn,
        isManual: true,
      );
    }
    final cachedGps = _readCachedGps(prefs);
    return (
      lat: cachedGps?.lat ?? LocationService.defaultCairoLat,
      lng: cachedGps?.lng ?? LocationService.defaultCairoLng,
      nameAr: cachedGps?.nameAr ?? LocationService.defaultCairoAr,
      nameEn: cachedGps?.nameEn ?? LocationService.defaultCairoEn,
      isManual: false,
    );
  }

  static Future<void> setManualLocation(
    SharedPreferences prefs, {
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  }) async {
    await prefs.setBool(AppConstants.isManualLocationKey, true);
    await prefs.setDouble(AppConstants.customLocationLatKey, lat);
    await prefs.setDouble(AppConstants.customLocationLngKey, lng);
    await prefs.setString(AppConstants.customLocationNameArKey, nameAr);
    await prefs.setString(AppConstants.customLocationNameEnKey, nameEn);
  }

  static Future<void> resetToGps(SharedPreferences prefs) async {
    await prefs.setBool(AppConstants.isManualLocationKey, false);
    await prefs.remove(AppConstants.customLocationLatKey);
    await prefs.remove(AppConstants.customLocationLngKey);
    await prefs.remove(AppConstants.customLocationNameArKey);
    await prefs.remove(AppConstants.customLocationNameEnKey);
  }
}
