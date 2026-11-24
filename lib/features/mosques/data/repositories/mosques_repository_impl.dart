import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/mosque.dart';
import '../../domain/repositories/mosques_repository.dart';
import '../datasources/mosques_remote_data_source.dart';

class MosquesRepositoryImpl implements MosquesRepository {
  final MosquesRemoteDataSource remoteDataSource;

  MosquesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Mosque>>> getNearbyMosques({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    try {
      final mosques = await remoteDataSource.fetchNearbyMosques(
        latitude: latitude,
        longitude: longitude,
        radiusInMeters: radiusInMeters,
      );

      // Sort by nearest distance first
      mosques.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));

      return Right(mosques);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
