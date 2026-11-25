import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/data/datasources/location_service.dart';

/// SharedPreferences storage helpers for manual & GPS location fallback state.
class SettingsLocationStore {
  const SettingsLocationStore._();

  static bool isManualLocation(SharedPreferences prefs) =>
      prefs.getBool(AppConstants.isManualLocationKey) ?? false;

  static ({double lat, double lng, String nameAr, String nameEn, bool isManual})
      getLocation(SharedPreferences prefs) {
    return (
      lat: prefs.getDouble(AppConstants.customLocationLatKey) ??
          LocationService.defaultCairoLat,
      lng: prefs.getDouble(AppConstants.customLocationLngKey) ??
          LocationService.defaultCairoLng,
      nameAr: prefs.getString(AppConstants.customLocationNameArKey) ??
          LocationService.defaultCairoAr,
      nameEn: prefs.getString(AppConstants.customLocationNameEnKey) ??
          LocationService.defaultCairoEn,
      isManual: isManualLocation(prefs),
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
