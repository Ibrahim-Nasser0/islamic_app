import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../hadith_catalog_database.dart';
import '../tables/hadith_catalog_tables.dart';
import 'hadith_search_helper.dart';

part 'hadith_dao.g.dart';

@DriftAccessor(tables: [HadithBooks, Hadiths])
class HadithDao extends DatabaseAccessor<HadithCatalogDatabase>
    with _$HadithDaoMixin {
  HadithDao(super.db);
  static final Random _random = Random();

  Expression<bool> _bookFilter(
    $HadithsTable t,
    String canonicalBookId,
    String? gradeTier,
  ) {
    final base = t.bookId.equals(canonicalBookId);
    return (gradeTier != null && gradeTier.isNotEmpty)
        ? base & t.gradeTier.equals(gradeTier)
        : base;
  }

  Expression<bool> _dailyFilter(
    $HadithsTable t, {
    required int maxLength,
    String? excludeBook,
    int? excludeNumber,
  }) {
    var cond = t.gradeTier.isIn(const ['muttafaq', 'sahih']) &
        t.textLength.isSmallerOrEqualValue(maxLength);
    if (excludeBook != null && excludeNumber != null) {
      cond = cond &
          (t.bookId.equals(excludeBook) & t.number.equals(excludeNumber)).not();
    }
    return cond;
  }

  Future<List<HadithBookRow>> getBooks() =>
      (select(hadithBooks)..orderBy([(b) => OrderingTerm.asc(b.id)])).get();

  Future<List<HadithCatalogRow>> getHadithsPage(
    String bookId, {
    required int limit,
    required int offset,
    String? gradeTier,
  }) {
    final canonical = HadithSearchHelper.canonicalBookId(bookId);
    return (select(hadiths)
          ..where((t) => _bookFilter(t, canonical, gradeTier))
          ..orderBy([(t) => OrderingTerm.asc(t.number)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<int> countHadiths(String bookId, {String? gradeTier}) async {
    final canonical = HadithSearchHelper.canonicalBookId(bookId);
    final countExp = hadiths.id.count();
    final row = await (selectOnly(hadiths)
          ..addColumns([countExp])
          ..where(_bookFilter(hadiths, canonical, gradeTier)))
        .getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<List<HadithCatalogRow>> searchHadithsFts(
    String bookId,
    String rawQuery, {
    int limit = 60,
    int offset = 0,
    String? gradeTier,
  }) async {
    final canonical = HadithSearchHelper.canonicalBookId(bookId);
    final ftsMatch = HadithSearchHelper.buildFtsMatchExpression(rawQuery);
    if (ftsMatch == null) {
      return getHadithsPage(canonical, limit: limit, offset: offset, gradeTier: gradeTier);
    }
    try {
      final hasGrade = gradeTier != null && gradeTier.isNotEmpty;
      final gradeClause = hasGrade ? 'AND h.grade_tier = ? ' : '';
      final rows = await customSelect(
        'SELECT h.* FROM hadiths h JOIN hadiths_fts f ON f.rowid = h.id '
        'WHERE hadiths_fts MATCH ? AND h.book_id = ? $gradeClause '
        'ORDER BY h.number ASC LIMIT ? OFFSET ?',
        variables: [
          Variable.withString(ftsMatch),
          Variable.withString(canonical),
          if (hasGrade) Variable.withString(gradeTier),
          Variable.withInt(limit),
          Variable.withInt(offset),
        ],
        readsFrom: {hadiths},
      ).get();
      return rows.map((r) => hadiths.map(r.data)).toList();
    } catch (e, stackTrace) {
      debugPrint('[HadithDao] FTS5 fallback for "$rawQuery": $e\n$stackTrace');
      final pattern = '%${rawQuery.trim()}%';
      return (select(hadiths)
            ..where((t) {
              final hit = t.arabicText.like(pattern) |
                  t.titleAr.like(pattern) |
                  t.chapterAr.like(pattern) |
                  t.number.cast<String>().equals(rawQuery.trim());
              return _bookFilter(t, canonical, gradeTier) & hit;
            })
            ..orderBy([(t) => OrderingTerm.asc(t.number)])
            ..limit(limit, offset: offset))
          .get();
    }
  }

  Future<HadithCatalogRow?> getHadithByNumber(String bookId, int number) {
    final canonical = HadithSearchHelper.canonicalBookId(bookId);
    return (select(hadiths)
          ..where((t) => t.bookId.equals(canonical) & t.number.equals(number)))
        .getSingleOrNull();
  }

  Future<int> _countDailyPool(int maxLength, {String? excludeBook, int? excludeNumber}) async {
    final countExp = hadiths.id.count();
    final row = await (selectOnly(hadiths)
          ..addColumns([countExp])
          ..where(_dailyFilter(hadiths, maxLength: maxLength, excludeBook: excludeBook, excludeNumber: excludeNumber)))
        .getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<HadithCatalogRow?> pickRandomDailySahihHadith({
    int? seedOffset,
    String? excludeBook,
    int? excludeNumber,
    int maxLength = 420,
  }) async {
    final exclBook = excludeBook == null ? null : HadithSearchHelper.canonicalBookId(excludeBook);
    var applyExcl = exclBook != null && excludeNumber != null;
    var poolCount = await _countDailyPool(
      maxLength,
      excludeBook: applyExcl ? exclBook : null,
      excludeNumber: applyExcl ? excludeNumber : null,
    );
    if (poolCount == 0 && applyExcl) {
      applyExcl = false;
      poolCount = await _countDailyPool(maxLength);
    }
    if (poolCount == 0) return null;
    final offset = seedOffset != null ? seedOffset.abs() % poolCount : _random.nextInt(poolCount);
    return (select(hadiths)
          ..where((t) => _dailyFilter(t, maxLength: maxLength, excludeBook: applyExcl ? exclBook : null, excludeNumber: applyExcl ? excludeNumber : null))
          ..limit(1, offset: offset))
        .getSingleOrNull();
  }

  Future<int> insertWithFtsForTesting(HadithsCompanion row, String ftsNormalizedText) async {
    final id = await into(hadiths).insert(row);
    await customStatement('INSERT INTO hadiths_fts(rowid, search_normalized) VALUES (?, ?)', [id, ftsNormalizedText]);
    return id;
  }
}
