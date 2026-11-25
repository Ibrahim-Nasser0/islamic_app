import 'dart:math' as math;
import 'package:geocoding/geocoding.dart';

/// Helper responsible for resolving city names accurately both offline & online.
class CityResolverHelper {
  CityResolverHelper._();

  static const List<({String nameAr, String nameEn, double lat, double lng})>
      _knownLocations = [
    (nameAr: 'القاهرة، مصر', nameEn: 'Cairo, Egypt', lat: 30.0444, lng: 31.2357),
    (nameAr: 'الجيزة، مصر', nameEn: 'Giza, Egypt', lat: 30.0131, lng: 31.2089),
    (nameAr: 'الإسكندرية، مصر', nameEn: 'Alexandria, Egypt', lat: 31.2001, lng: 29.9187),
    (nameAr: 'القليوبية، مصر', nameEn: 'Qalyubia, Egypt', lat: 30.4591, lng: 31.1786),
    (nameAr: 'المنصورة، مصر', nameEn: 'Mansoura, Egypt', lat: 31.0409, lng: 31.3785),
    (nameAr: 'طنطا، مصر', nameEn: 'Tanta, Egypt', lat: 30.7865, lng: 31.0004),
    (nameAr: 'الشرقية، مصر', nameEn: 'Sharqia, Egypt', lat: 30.5877, lng: 31.5020),
    (nameAr: 'المنوفية، مصر', nameEn: 'Menofia, Egypt', lat: 30.5567, lng: 31.0079),
    (nameAr: 'كفر الشيخ، مصر', nameEn: 'Kafr El Sheikh, Egypt', lat: 31.1107, lng: 30.9388),
    (nameAr: 'دمنهور، مصر', nameEn: 'Damanhur, Egypt', lat: 31.0379, lng: 30.4728),
    (nameAr: 'دمياط، مصر', nameEn: 'Damietta, Egypt', lat: 31.4175, lng: 31.8144),
    (nameAr: 'بورسعيد، مصر', nameEn: 'Port Said, Egypt', lat: 31.2653, lng: 32.3019),
    (nameAr: 'الإسماعيلية، مصر', nameEn: 'Ismailia, Egypt', lat: 30.5965, lng: 32.2715),
    (nameAr: 'السويس، مصر', nameEn: 'Suez, Egypt', lat: 29.9668, lng: 32.5498),
    (nameAr: 'الفيوم، مصر', nameEn: 'Fayoum, Egypt', lat: 29.3084, lng: 30.8428),
    (nameAr: 'بني سويف، مصر', nameEn: 'Beni Suef, Egypt', lat: 29.0661, lng: 31.0994),
    (nameAr: 'المنيا، مصر', nameEn: 'Minya, Egypt', lat: 28.0871, lng: 30.7618),
    (nameAr: 'أسيوط، مصر', nameEn: 'Assiut, Egypt', lat: 27.1801, lng: 31.1837),
    (nameAr: 'سوهاج، مصر', nameEn: 'Sohag, Egypt', lat: 26.5590, lng: 31.6957),
    (nameAr: 'قنا، مصر', nameEn: 'Qena, Egypt', lat: 26.1551, lng: 32.7160),
    (nameAr: 'الأقصر، مصر', nameEn: 'Luxor, Egypt', lat: 25.6872, lng: 32.6396),
    (nameAr: 'أسوان، مصر', nameEn: 'Aswan, Egypt', lat: 24.0889, lng: 32.8998),
    (nameAr: 'الغردقة، مصر', nameEn: 'Hurghada, Egypt', lat: 27.2579, lng: 33.8116),
    (nameAr: 'شرم الشيخ، مصر', nameEn: 'Sharm El-Sheikh, Egypt', lat: 27.9158, lng: 34.3299),
    (nameAr: 'العريش، مصر', nameEn: 'Arish, Egypt', lat: 31.1316, lng: 33.7984),
    (nameAr: 'مطروح، مصر', nameEn: 'Matrouh, Egypt', lat: 31.3543, lng: 27.2373),
    (nameAr: 'مكة المكرمة', nameEn: 'Makkah', lat: 21.4225, lng: 39.8262),
    (nameAr: 'المدينة المنورة', nameEn: 'Madinah', lat: 24.5247, lng: 39.5692),
    (nameAr: 'جدة، السعودية', nameEn: 'Jeddah, Saudi Arabia', lat: 21.4858, lng: 39.1925),
    (nameAr: 'الرياض، السعودية', nameEn: 'Riyadh, Saudi Arabia', lat: 24.7136, lng: 46.6753),
    (nameAr: 'الدمام، السعودية', nameEn: 'Dammam, Saudi Arabia', lat: 26.4207, lng: 50.0888),
    (nameAr: 'دبي، الإمارات', nameEn: 'Dubai, UAE', lat: 25.2048, lng: 55.2708),
    (nameAr: 'أبوظبي، الإمارات', nameEn: 'Abu Dhabi, UAE', lat: 24.4539, lng: 54.3773),
    (nameAr: 'الدوحة، قطر', nameEn: 'Doha, Qatar', lat: 25.2854, lng: 51.5310),
    (nameAr: 'الكويت، الكويت', nameEn: 'Kuwait City, Kuwait', lat: 29.3759, lng: 47.9774),
    (nameAr: 'عمان، الأردن', nameEn: 'Amman, Jordan', lat: 31.9454, lng: 35.9284),
    (nameAr: 'القدس الشريف', nameEn: 'Jerusalem', lat: 31.7683, lng: 35.2137),
    (nameAr: 'الدار البيضاء، المغرب', nameEn: 'Casablanca, Morocco', lat: 33.5731, lng: -7.5898),
    (nameAr: 'الجزائر، الجزائر', nameEn: 'Algiers, Algeria', lat: 36.7538, lng: 3.0588),
    (nameAr: 'تونس، تونس', nameEn: 'Tunis, Tunisia', lat: 36.8065, lng: 10.1815),
  ];

  static List<({String nameAr, String nameEn, double lat, double lng})>
      get knownLocations => _knownLocations;

  /// Resolves bilingual city names cleanly: instant match within 35km of known
  /// cities, otherwise online geocoding with clean offline fallback.
  static Future<({String nameAr, String nameEn})> resolveCity({
    required double latitude,
    required double longitude,
  }) async {
    final nearest = _findNearestWithDistance(latitude, longitude);
    if (nearest.distanceKm <= 35.0) {
      return (nameAr: nearest.city.nameAr, nameEn: nearest.city.nameEn);
    }

    try {
      final geocoding = Geocoding();
      final placemarks = await geocoding
          .placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 4));

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          p.locality ?? '',
          p.subAdministrativeArea ?? '',
          (p.administrativeArea ?? '')
              .replaceAll('Governorate', '')
              .replaceAll('محافظة', ''),
        ].map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

        final country = (p.country ?? '').trim();
        if (parts.isNotEmpty) {
          final city = parts.first;
          final titleAr = country.isNotEmpty ? '$city، $country' : city;
          final titleEn = country.isNotEmpty ? '$city, $country' : city;
          return (nameAr: titleAr, nameEn: titleEn);
        }
      }
    } catch (_) {
      // Fall back below if offline or geocoder unavailable
    }

    if (nearest.distanceKm <= 220.0) {
      return (nameAr: nearest.city.nameAr, nameEn: nearest.city.nameEn);
    }

    final coordsLabel =
        '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
    return (nameAr: coordsLabel, nameEn: coordsLabel);
  }

  static ({String nameAr, String nameEn}) findNearestCity(double lat, double lng) {
    final res = _findNearestWithDistance(lat, lng);
    return (nameAr: res.city.nameAr, nameEn: res.city.nameEn);
  }

  static ({({String nameAr, String nameEn, double lat, double lng}) city, double distanceKm})
      _findNearestWithDistance(double lat, double lng) {
    var nearest = _knownLocations.first;
    var minDist = double.infinity;

    for (final loc in _knownLocations) {
      final d = _haversineKm(lat, lng, loc.lat, loc.lng);
      if (d < minDist) {
        minDist = d;
        nearest = loc;
      }
    }
    return (city: nearest, distanceKm: minDist);
  }

  static double _haversineKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180.0;
    final dLng = (lng2 - lng1) * math.pi / 180.0;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180.0) *
            math.cos(lat2 * math.pi / 180.0) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 * r * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }
}
