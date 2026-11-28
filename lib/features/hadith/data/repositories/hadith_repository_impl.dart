import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/daily_hadith_entry.dart';
import '../../domain/entities/hadith_item.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../datasources/hadith_local_data_source.dart';

class HadithRepositoryImpl implements HadithRepository {
  final HadithLocalDataSource localDataSource;

  HadithRepositoryImpl({required this.localDataSource});

  Future<Either<Failure, T>> _guard<T>(
    String op,
    Future<T> Function() action,
  ) async {
    try {
      return Right(await action());
    } on AppException catch (e, stackTrace) {
      debugPrint('[HadithRepository] $op failed: ${e.message}\n$stackTrace');
      return Left(CacheFailure(e.message, message: e.message));
    } catch (e, stackTrace) {
      debugPrint('[HadithRepository] $op unexpected error: $e\n$stackTrace');
      return Left(CacheFailure(e.toString(), message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HadithItem>>> getHadithsPage(
    String bookId, {
    required int limit,
    required int offset,
    String? gradeTier,
    String? searchQuery,
  }) =>
      _guard(
        'getHadithsPage($bookId, offset: $offset)',
        () => localDataSource.getHadithsPage(
          bookId,
          limit: limit,
          offset: offset,
          gradeTier: gradeTier,
          searchQuery: searchQuery,
        ),
      );

  @override
  Future<Either<Failure, int>> countHadiths(
    String bookId, {
    String? gradeTier,
  }) =>
      _guard(
        'countHadiths($bookId)',
        () => localDataSource.countHadiths(bookId, gradeTier: gradeTier),
      );

  @override
  Future<Either<Failure, HadithItem>> getHadithByNumber(
    String bookId,
    int number,
  ) =>
      _guard(
        'getHadithByNumber($bookId, $number)',
        () => localDataSource.getHadithByNumber(bookId, number),
      );

  @override
  Future<Either<Failure, DailyHadithEntry>> pickDailySahihHadith({
    int? seedOffset,
    String? excludeBook,
    int? excludeNumber,
  }) =>
      _guard(
        'pickDailySahihHadith',
        () => localDataSource.pickDailySahihHadith(
          seedOffset: seedOffset,
          excludeBook: excludeBook,
          excludeNumber: excludeNumber,
        ),
      );

  @override
  Future<Either<Failure, Map<String, int>>> getBookCounts() =>
      _guard('getBookCounts', localDataSource.getBookCounts);
}
