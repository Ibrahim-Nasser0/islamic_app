import 'package:dartz/dartz.dart';
import 'package:islamic_app/core/errors/failure.dart';


import '../../domain/entities/hadith_item.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../datasources/hadith_local_data_source.dart';

class HadithRepositoryImpl implements HadithRepository {
  final HadithLocalDataSource localDataSource;

  HadithRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<HadithItem>>> getHadithsByBook(String bookId) async {
    try {
      final list = await localDataSource.getHadithsByBook(bookId);
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HadithItem>> getHadithByNumber(String bookId, int number) async {
    try {
      final item = await localDataSource.getHadithByNumber(bookId, number);
      if (item != null) {
        return Right(item);
      }
      return const Left(CacheFailure('Hadith not found'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
