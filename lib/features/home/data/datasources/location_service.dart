import 'package:geolocator/geolocator.dart';

/// Service responsible for acquiring device GPS coordinates with offline fallbacks
class LocationService {
  static const double defaultCairoLat = 30.0444;
  static const double defaultCairoLng = 31.2357;
  static const String defaultCairoName = 'القاهرة، مصر';

  Future<({double latitude, double longitude, String locationName})>
      getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return (
          latitude: defaultCairoLat,
          longitude: defaultCairoLng,
          locationName: defaultCairoName,
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return (
            latitude: defaultCairoLat,
            longitude: defaultCairoLng,
            locationName: defaultCairoName,
          );
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      return (
        latitude: position.latitude,
        longitude: position.longitude,
        locationName: 'موقعك الحالي',
      );
    } catch (_) {
      return (
        latitude: defaultCairoLat,
        longitude: defaultCairoLng,
        locationName: defaultCairoName,
      );
    }
  }
}
