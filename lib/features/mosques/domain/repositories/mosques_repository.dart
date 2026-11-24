import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/mosque.dart';

/// Contract for Mosques Repository
abstract class MosquesRepository {
  Future<Either<Failure, List<Mosque>>> getNearbyMosques({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  });
}
