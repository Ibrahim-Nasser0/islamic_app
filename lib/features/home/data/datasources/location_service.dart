import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_preference_service.dart';
import 'city_resolver_helper.dart';

/// Outcome status of an automatic GPS acquisition attempt.
enum LocationAcquireStatus {
  gpsSuccess,
  lastKnownFallback,
  cachedFallback,
  gpsDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
}

typedef LocationAcquireResult = ({
  double latitude,
  double longitude,
  String nameAr,
  String nameEn,
  LocationAcquireStatus status,
});

/// Acquires device GPS coordinates with multi-stage fallback (live -> lastKnown -> cached -> Cairo).
class LocationService {
  static const double defaultCairoLat = 30.0444;
  static const double defaultCairoLng = 31.2357;
  static const String defaultCairoAr = 'القاهرة، مصر';
  static const String defaultCairoEn = 'Cairo, Egypt';

  Future<({double latitude, double longitude, String nameAr, String nameEn})>
      getCurrentLocation() async {
    final res = await acquireLocation(requestPermission: true);
    return (
      latitude: res.latitude,
      longitude: res.longitude,
      nameAr: res.nameAr,
      nameEn: res.nameEn,
    );
  }

  Future<LocationAcquireResult> acquireLocation({
    bool requestPermission = true,
  }) async {
    final fallback = await LocationPreferenceService.getCachedGpsOrDefault();
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _fallbackResult(fallback, LocationAcquireStatus.gpsDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return _fallbackResult(
          fallback,
          LocationAcquireStatus.permissionDeniedForever,
        );
      }
      if (permission == LocationPermission.denied) {
        if (!requestPermission) {
          return _fallbackResult(
            fallback,
            LocationAcquireStatus.permissionDenied,
          );
        }
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return _fallbackResult(
            fallback,
            LocationAcquireStatus.permissionDeniedForever,
          );
        }
        if (permission == LocationPermission.denied) {
          return _fallbackResult(
            fallback,
            LocationAcquireStatus.permissionDenied,
          );
        }
      }

      final lastKnown = await _safeLastKnownPosition();
      try {
        final live = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 10),
          ),
        );
        return await _resolveAndCache(
          live,
          LocationAcquireStatus.gpsSuccess,
        );
      } catch (_) {
        if (lastKnown != null) {
          return await _resolveAndCache(
            lastKnown,
            LocationAcquireStatus.lastKnownFallback,
          );
        }
        return _fallbackResult(fallback, LocationAcquireStatus.timeout);
      }
    } catch (_) {
      return _fallbackResult(fallback, LocationAcquireStatus.cachedFallback);
    }
  }

  Future<Position?> _safeLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  Future<LocationAcquireResult> _resolveAndCache(
    Position pos,
    LocationAcquireStatus status,
  ) async {
    final city = await CityResolverHelper.resolveCity(
      latitude: pos.latitude,
      longitude: pos.longitude,
    );
    await LocationPreferenceService.cacheGpsLocation(
      latitude: pos.latitude,
      longitude: pos.longitude,
      nameAr: city.nameAr,
      nameEn: city.nameEn,
    );
    return (
      latitude: pos.latitude,
      longitude: pos.longitude,
      nameAr: city.nameAr,
      nameEn: city.nameEn,
      status: status,
    );
  }

  LocationAcquireResult _fallbackResult(
    SavedLocationRecord fallback,
    LocationAcquireStatus status,
  ) =>
      (
        latitude: fallback.latitude,
        longitude: fallback.longitude,
        nameAr: fallback.nameAr,
        nameEn: fallback.nameEn,
        status: status,
      );
}
