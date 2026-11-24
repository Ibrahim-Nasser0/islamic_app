import 'package:geolocator/geolocator.dart';
import '../../domain/entities/mosque.dart';

/// Mosque Data Model with OSM Overpass JSON serialization
class MosqueModel extends Mosque {
  const MosqueModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.distanceInMeters,
    super.street,
  });

  factory MosqueModel.fromOverpassJson(
    Map<String, dynamic> json, {
    required double userLat,
    required double userLng,
  }) {
    final id = json['id']?.toString() ?? 'unknown_${DateTime.now().microsecondsSinceEpoch}';
    final tags = (json['tags'] as Map<String, dynamic>?) ?? {};

    double lat = 0.0;
    double lon = 0.0;

    if (json.containsKey('lat') && json.containsKey('lon')) {
      lat = (json['lat'] as num).toDouble();
      lon = (json['lon'] as num).toDouble();
    } else if (json.containsKey('center') && json['center'] is Map) {
      final center = json['center'] as Map<String, dynamic>;
      lat = (center['lat'] as num).toDouble();
      lon = (center['lon'] as num).toDouble();
    }

    final arabicName = tags['name:ar'] as String?;
    final defaultName = tags['name'] as String?;
    final englishName = tags['name:en'] as String?;
    final street = (tags['addr:street'] ?? tags['addr:full']) as String?;

    final resolvedName = (arabicName != null && arabicName.trim().isNotEmpty)
        ? arabicName.trim()
        : (defaultName != null && defaultName.trim().isNotEmpty)
            ? defaultName.trim()
            : (englishName != null && englishName.trim().isNotEmpty)
                ? englishName.trim()
                : 'مسجد';

    final distance = Geolocator.distanceBetween(userLat, userLng, lat, lon);

    return MosqueModel(
      id: id,
      name: resolvedName,
      latitude: lat,
      longitude: lon,
      distanceInMeters: distance,
      street: street,
    );
  }

  factory MosqueModel.fromPhotonJson(
    Map<String, dynamic> json, {
    required double userLat,
    required double userLng,
  }) {
    final properties = (json['properties'] as Map<String, dynamic>?) ?? {};
    final geometry = (json['geometry'] as Map<String, dynamic>?) ?? {};
    final coordinates = (geometry['coordinates'] as List?) ?? [0.0, 0.0];

    final lon =
        (coordinates.isNotEmpty ? coordinates[0] as num : 0.0).toDouble();
    final lat =
        (coordinates.length > 1 ? coordinates[1] as num : 0.0).toDouble();

    final id = properties['osm_id']?.toString() ??
        'photon_${DateTime.now().microsecondsSinceEpoch}';
    final rawName = properties['name'] as String? ?? '';
    final streetName = properties['street'] as String?;
    final locality =
        (properties['locality'] ?? properties['district']) as String?;
    final city = properties['city'] as String?;
    final fullStreet = [
      if (streetName != null && streetName.isNotEmpty) streetName,
      if (locality != null && locality.isNotEmpty) locality,
      if (city != null && city.isNotEmpty && streetName == null) city,
    ].join(' • ');

    final distance = Geolocator.distanceBetween(userLat, userLng, lat, lon);

    return MosqueModel(
      id: id,
      name: rawName.trim().isNotEmpty ? rawName.trim() : 'مسجد',
      latitude: lat,
      longitude: lon,
      distanceInMeters: distance,
      street: fullStreet.isNotEmpty ? fullStreet : null,
    );
  }
}
