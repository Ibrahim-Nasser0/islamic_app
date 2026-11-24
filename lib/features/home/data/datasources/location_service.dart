import 'package:geolocator/geolocator.dart';
import 'city_resolver_helper.dart';

/// Service responsible for acquiring device GPS coordinates with offline fallbacks
class LocationService {
  static const double defaultCairoLat = 30.0444;
  static const double defaultCairoLng = 31.2357;
  static const String defaultCairoAr = 'القاهرة، مصر';
  static const String defaultCairoEn = 'Cairo, Egypt';

  Future<({double latitude, double longitude, String nameAr, String nameEn})>
      getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return (
          latitude: defaultCairoLat,
          longitude: defaultCairoLng,
          nameAr: defaultCairoAr,
          nameEn: defaultCairoEn,
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return (
          latitude: defaultCairoLat,
          longitude: defaultCairoLng,
          nameAr: defaultCairoAr,
          nameEn: defaultCairoEn,
        );
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return (
            latitude: defaultCairoLat,
            longitude: defaultCairoLng,
            nameAr: defaultCairoAr,
            nameEn: defaultCairoEn,
          );
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final city = await CityResolverHelper.resolveCity(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return (
        latitude: position.latitude,
        longitude: position.longitude,
        nameAr: city.nameAr,
        nameEn: city.nameEn,
      );
    } catch (_) {
      return (
        latitude: defaultCairoLat,
        longitude: defaultCairoLng,
        nameAr: defaultCairoAr,
        nameEn: defaultCairoEn,
      );
    }
  }
}
