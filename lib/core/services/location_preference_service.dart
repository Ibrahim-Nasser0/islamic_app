import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/data/datasources/location_service.dart';
import '../utils/constants.dart';


import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../../features/home/data/datasources/location_service.dart';

class LocationPreferenceService {
  static Future<({
    double latitude,
    double longitude,
    String nameAr,
    String nameEn,
    bool isManual,
  })> getActiveLocation({LocationService? locationService}) async {
    final prefs = await SharedPreferences.getInstance();
    final isManual =
        prefs.getBool(AppConstants.isManualLocationKey) ?? false;

    if (isManual) {
      final lat = prefs.getDouble(AppConstants.customLocationLatKey) ??
          LocationService.defaultCairoLat;
      final lng = prefs.getDouble(AppConstants.customLocationLngKey) ??
          LocationService.defaultCairoLng;
      final nameAr =
          prefs.getString(AppConstants.customLocationNameArKey) ??
              LocationService.defaultCairoAr;
      final nameEn =
          prefs.getString(AppConstants.customLocationNameEnKey) ??
              LocationService.defaultCairoEn;
      return (
        latitude: lat,
        longitude: lng,
        nameAr: nameAr,
        nameEn: nameEn,
        isManual: true,
      );
    }

    final service = locationService ?? LocationService();
    final gpsLoc = await service.getCurrentLocation();
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
    await prefs.setBool(AppConstants.isManualLocationKey, true);
    await prefs.setDouble(AppConstants.customLocationLatKey, latitude);
    await prefs.setDouble(AppConstants.customLocationLngKey, longitude);
    await prefs.setString(AppConstants.customLocationNameArKey, nameAr);
    await prefs.setString(AppConstants.customLocationNameEnKey, nameEn);
  }

  static Future<void> resetToGps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isManualLocationKey, false);
    await prefs.remove(AppConstants.customLocationLatKey);
    await prefs.remove(AppConstants.customLocationLngKey);
    await prefs.remove(AppConstants.customLocationNameArKey);
    await prefs.remove(AppConstants.customLocationNameEnKey);
  }

  static Future<bool> isManual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isManualLocationKey) ?? false;
  }
}
