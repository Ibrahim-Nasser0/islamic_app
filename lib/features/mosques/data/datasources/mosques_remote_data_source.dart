import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/mosque_model.dart';

abstract class MosquesRemoteDataSource {
  Future<List<MosqueModel>> fetchNearbyMosques({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  });
}

class MosquesRemoteDataSourceImpl implements MosquesRemoteDataSource {
  final Dio dio;

  MosquesRemoteDataSourceImpl({required this.dio});

  static const Map<String, String> _customHeaders = {
    'User-Agent':
        'ZadAlMuslim/1.0 (Android; com.zad.almuslim; contact: support@zad.app)',
    'Accept': '*/*',
  };

  static const List<String> _overpassEndpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://lz4.overpass-api.de/api/interpreter',
  ];

  @override
  Future<List<MosqueModel>> fetchNearbyMosques({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    // 1. High-speed primary fetch via Photon (OpenStreetMap POI service)
    try {
      final photonMosques = await _fetchFromPhoton(
        latitude: latitude,
        longitude: longitude,
        radiusInMeters: radiusInMeters,
      );
      if (photonMosques.isNotEmpty) {
        return photonMosques;
      }
    } catch (_) {
      // Continue to Overpass fallback
    }

    // 2. Fallback to Overpass API with short connect timeout (max 4 seconds)
    final overpassMosques = await _fetchFromOverpass(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
    );

    if (overpassMosques.isNotEmpty) {
      return overpassMosques;
    }

    throw ServerException(message: 'Failed to fetch mosques from all endpoints');
  }

  Future<List<MosqueModel>> _fetchFromPhoton({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    final url =
        'https://photon.komoot.io/api/?q=%D9%85%D8%B3%D8%AC%D8%AF&lat=$latitude&lon=$longitude&limit=40';

    final response = await dio.get(
      url,
      options: Options(
        headers: _customHeaders,
        sendTimeout: const Duration(seconds: 4),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    if (response.statusCode == 200 && response.data is Map) {
      final features = response.data['features'] as List? ?? [];
      final mosques = features
          .whereType<Map<String, dynamic>>()
          .map((f) => MosqueModel.fromPhotonJson(
                f,
                userLat: latitude,
                userLng: longitude,
              ))
          .where((m) => m.latitude != 0.0 && m.longitude != 0.0)
          .toList();

      final filtered = mosques
          .where((m) => m.distanceInMeters <= (radiusInMeters * 1.5))
          .toList();

      return filtered.isNotEmpty ? filtered : mosques.take(15).toList();
    }
    return [];
  }

  Future<List<MosqueModel>> _fetchFromOverpass({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    final radius = radiusInMeters.round();
    final query = '''
[out:json][timeout:5];
(
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$radius,$latitude,$longitude);
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$radius,$latitude,$longitude);
);
out center body;
''';

    for (final endpoint in _overpassEndpoints) {
      try {
        final response = await dio.post(
          endpoint,
          data: {'data': query},
          options: Options(
            headers: _customHeaders,
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.plain,
            sendTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 5),
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          final decoded = jsonDecode(response.data as String);
          if (decoded is Map && decoded.containsKey('elements')) {
            final elements = decoded['elements'] as List? ?? [];
            final mosques = elements
                .whereType<Map<String, dynamic>>()
                .map((el) => MosqueModel.fromOverpassJson(
                      el,
                      userLat: latitude,
                      userLng: longitude,
                    ))
                .where((m) => m.latitude != 0.0 && m.longitude != 0.0)
                .toList();

            if (mosques.isNotEmpty) return mosques;
          }
        }
      } catch (_) {
        continue;
      }
    }
    return [];
  }
}
