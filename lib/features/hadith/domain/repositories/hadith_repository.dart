import 'package:dartz/dartz.dart';
import 'package:islamic_app/core/errors/failure.dart';

import '../entities/daily_hadith_entry.dart';
import '../entities/hadith_item.dart';

abstract class HadithRepository {
  Future<Either<Failure, List<HadithItem>>> getHadithsByBook(String bookId);
  Future<Either<Failure, HadithItem>> getHadithByNumber(String bookId, int number);
  Future<Either<Failure, List<DailyHadithEntry>>> getAllHadithsPool();
}
