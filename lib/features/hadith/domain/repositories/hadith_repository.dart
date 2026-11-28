import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/daily_hadith_entry.dart';
import '../entities/hadith_item.dart';

abstract class HadithRepository {
  Future<Either<Failure, List<HadithItem>>> getHadithsPage(
    String bookId, {
    required int limit,
    required int offset,
    String? gradeTier,
    String? searchQuery,
  });

  Future<Either<Failure, int>> countHadiths(
    String bookId, {
    String? gradeTier,
  });

  Future<Either<Failure, HadithItem>> getHadithByNumber(
    String bookId,
    int number,
  );

  Future<Either<Failure, DailyHadithEntry>> pickDailySahihHadith({
    int? seedOffset,
    String? excludeBook,
    int? excludeNumber,
  });

  Future<Either<Failure, Map<String, int>>> getBookCounts();
}
