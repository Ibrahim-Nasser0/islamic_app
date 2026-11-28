import '../../../../core/database/daos/hadith_dao.dart';
import '../../../../core/database/daos/hadith_search_helper.dart';
import '../../../../core/database/hadith_catalog_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/daily_hadith_entry.dart';
import '../../domain/entities/hadith_item.dart';

abstract class HadithLocalDataSource {
  Future<List<HadithItem>> getHadithsPage(
    String bookId, {
    required int limit,
    required int offset,
    String? gradeTier,
    String? searchQuery,
  });

  Future<int> countHadiths(String bookId, {String? gradeTier});

  Future<HadithItem> getHadithByNumber(String bookId, int number);

  Future<DailyHadithEntry> pickDailySahihHadith({
    int? seedOffset,
    String? excludeBook,
    int? excludeNumber,
  });

  Future<Map<String, int>> getBookCounts();
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  static HadithCatalogDatabase? _fallbackDb;
  final HadithDao? hadithDao;

  HadithLocalDataSourceImpl({this.hadithDao});

  HadithDao get _dao {
    if (hadithDao != null) return hadithDao!;
    _fallbackDb ??= HadithCatalogDatabase();
    return _fallbackDb!.hadithDao;
  }

  HadithItem _toEntity(HadithCatalogRow row) {
    return HadithItem(
      number: row.number,
      title: row.titleAr,
      arabicText: row.arabicText,
      narrator: row.narrator,
      reference: row.reference,
      benefit: row.benefit,
      chapter: row.chapterAr,
      gradeTier: row.gradeTier,
      gradeLabelAr: row.gradeLabelAr,
      gradeLabelEn: row.gradeLabelEn,
      strengthScore: row.strengthScore,
    );
  }

  @override
  Future<List<HadithItem>> getHadithsPage(
    String bookId, {
    required int limit,
    required int offset,
    String? gradeTier,
    String? searchQuery,
  }) async {
    final trimmed = searchQuery?.trim() ?? '';
    final rows = trimmed.isNotEmpty
        ? await _dao.searchHadithsFts(
            bookId,
            trimmed,
            limit: limit,
            offset: offset,
            gradeTier: gradeTier,
          )
        : await _dao.getHadithsPage(
            bookId,
            limit: limit,
            offset: offset,
            gradeTier: gradeTier,
          );
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> countHadiths(String bookId, {String? gradeTier}) {
    return _dao.countHadiths(bookId, gradeTier: gradeTier);
  }

  @override
  Future<HadithItem> getHadithByNumber(String bookId, int number) async {
    final row = await _dao.getHadithByNumber(bookId, number);
    if (row == null) {
      throw CacheException(
        message: 'Hadith #$number not found in catalog ($bookId)',
      );
    }
    return _toEntity(row);
  }

  @override
  Future<DailyHadithEntry> pickDailySahihHadith({
    int? seedOffset,
    String? excludeBook,
    int? excludeNumber,
  }) async {
    final row = await _dao.pickRandomDailySahihHadith(
      seedOffset: seedOffset,
      excludeBook: excludeBook,
      excludeNumber: excludeNumber,
    );
    if (row == null) {
      throw CacheException(
        message: 'No verified Sahih daily Hadith found in catalog.',
      );
    }
    return DailyHadithEntry(
      bookId: HadithSearchHelper.translationKeyForBook(row.bookId),
      hadith: _toEntity(row),
    );
  }

  @override
  Future<Map<String, int>> getBookCounts() async {
    final books = await _dao.getBooks();
    return {
      for (final b in books)
        HadithSearchHelper.translationKeyForBook(b.id): b.totalCount,
    };
  }
}
