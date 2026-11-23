import 'package:dartz/dartz.dart';
import 'package:islamic_app/core/errors/failure.dart';


import '../entities/azkar_category.dart';

abstract class AzkarRepository {
  Future<Either<Failure, List<AzkarCategory>>> getCategories();
  Future<Either<Failure, AzkarCategory>> getCategoryById(String id);
  Future<Either<Failure, void>> updateDhikrCount(
    String categoryId,
    String dhikrId,
    int remaining,
  );
  Future<Either<Failure, void>> resetCategory(String categoryId);
}
