import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/data/datasources/location_service.dart';

class LocationPreferenceService {
  static const String keyIsManual = 'is_manual_location';
  static const String keyLat = 'custom_location_lat';
  static const String keyLng = 'custom_location_lng';
  static const String keyNameAr = 'custom_location_name_ar';
  static const String keyNameEn = 'custom_location_name_en';

  static Future<({
    double latitude,
    double longitude,
    String nameAr,
    String nameEn,
    bool isManual,
  })> getActiveLocation({LocationService? locationService}) async {
    final prefs = await SharedPreferences.getInstance();
    final isManual = prefs.getBool(keyIsManual) ?? false;

    if (isManual) {
      final lat = prefs.getDouble(keyLat) ?? LocationService.defaultCairoLat;
      final lng = prefs.getDouble(keyLng) ?? LocationService.defaultCairoLng;
      final nameAr =
          prefs.getString(keyNameAr) ?? LocationService.defaultCairoAr;
      final nameEn =
          prefs.getString(keyNameEn) ?? LocationService.defaultCairoEn;
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
    await prefs.setBool(keyIsManual, true);
    await prefs.setDouble(keyLat, latitude);
    await prefs.setDouble(keyLng, longitude);
    await prefs.setString(keyNameAr, nameAr);
    await prefs.setString(keyNameEn, nameEn);
  }

  static Future<void> resetToGps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsManual, false);
    await prefs.remove(keyLat);
    await prefs.remove(keyLng);
    await prefs.remove(keyNameAr);
    await prefs.remove(keyNameEn);
  }

  static Future<bool> isManual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsManual) ?? false;
  }
}
