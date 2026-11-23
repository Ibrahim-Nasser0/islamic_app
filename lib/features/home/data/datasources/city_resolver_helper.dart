import 'dart:math' as math;
import 'package:geocoding/geocoding.dart';

/// Helper responsible for resolving governorate/city names both online and offline
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
    (nameAr: 'الرياض، السعودية', nameEn: 'Riyadh, Saudi Arabia', lat: 24.7136, lng: 46.6753),
  ];

  static Future<({String nameAr, String nameEn})> resolveCity({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final geocoding = Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(const Duration(seconds: 2));

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final admin = (p.administrativeArea ?? '')
            .replaceAll('Governorate', '')
            .replaceAll('محافظة', '')
            .trim();
        final local = (p.locality ?? '').trim();
        final country = (p.country ?? '').trim();

        final candidate = admin.isNotEmpty ? admin : local;
        if (candidate.isNotEmpty) {
          final title = country.isNotEmpty ? '$candidate، $country' : candidate;
          return (nameAr: title, nameEn: title);
        }
      }
    } catch (_) {
      // Fallback to offline nearest calculation
    }

    return findNearestCity(latitude, longitude);
  }

  static ({String nameAr, String nameEn}) findNearestCity(
    double lat,
    double lng,
  ) {
    var nearest = _knownLocations.first;
    double minDistance = double.infinity;

    for (final loc in _knownLocations) {
      final double dLat = (lat - loc.lat);
      final double dLng = (lng - loc.lng) * math.cos(lat * math.pi / 180);
      final double dist = dLat * dLat + dLng * dLng;

      if (dist < minDistance) {
        minDistance = dist;
        nearest = loc;
      }
    }

    return (nameAr: nearest.nameAr, nameEn: nearest.nameEn);
  }
}
