import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:islamic_app/core/errors/failure.dart';

import '../../domain/entities/daily_hadith_entry.dart';
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
    } catch (e, stackTrace) {
      debugPrint('[HadithRepository] getHadithsByBook($bookId) failed: $e\n$stackTrace');
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
    } catch (e, stackTrace) {
      debugPrint('[HadithRepository] getHadithByNumber($bookId, $number) failed: $e\n$stackTrace');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DailyHadithEntry>>> getAllHadithsPool() async {
    try {
      final pool = await localDataSource.getAllHadithsPool();
      return Right(pool);
    } catch (e, stackTrace) {
      debugPrint('[HadithRepository] getAllHadithsPool failed: $e\n$stackTrace');
      return Left(CacheFailure(e.toString()));
    }
  }
}
