import 'package:dartz/dartz.dart';
import 'package:islamic_app/core/errors/failure.dart';


import '../../domain/entities/azkar_category.dart';
import '../../domain/repositories/azkar_repository.dart';
import '../datasources/azkar_local_data_source.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  final AzkarLocalDataSource localDataSource;

  AzkarRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<AzkarCategory>>> getCategories() async {
    try {
      final categories = await localDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, AzkarCategory>> getCategoryById(String id) async {
    try {
      final category = await localDataSource.getCategoryById(id);
      return Right(category);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDhikrCount(
    String categoryId,
    String dhikrId,
    int remaining,
  ) async {
    try {
      await localDataSource.updateDhikrCount(categoryId, dhikrId, remaining);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetCategory(String categoryId) async {
    try {
      await localDataSource.resetCategory(categoryId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
