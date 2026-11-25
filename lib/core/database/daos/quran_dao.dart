import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/quran_tables.dart';

part 'quran_dao.g.dart';

@DriftAccessor(tables: [QuranBookmarks, QuranReadingStates])
class QuranDao extends DatabaseAccessor<AppDatabase> with _$QuranDaoMixin {
  QuranDao(super.db);

  Future<List<QuranBookmarkRow>> getBookmarks() =>
      (select(quranBookmarks)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<void> toggleBookmark({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    DateTime? createdAt,
  }) async {
    final existing = await (select(quranBookmarks)
          ..where((t) =>
              t.surahNumber.equals(surahNumber) &
              t.ayahNumber.equals(ayahNumber)))
        .getSingleOrNull();

    if (existing != null) {
      await (delete(quranBookmarks)..where((t) => t.id.equals(existing.id)))
          .go();
    } else {
      await into(quranBookmarks).insert(
        QuranBookmarksCompanion.insert(
          surahNumber: surahNumber,
          surahName: surahName,
          ayahNumber: ayahNumber,
          createdAt: Value(createdAt ?? DateTime.now()),
        ),
      );
    }
  }

  Future<void> upsertBookmarkRow({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    required DateTime createdAt,
  }) async {
    await into(quranBookmarks).insert(
      QuranBookmarksCompanion.insert(
        surahNumber: surahNumber,
        surahName: surahName,
        ayahNumber: ayahNumber,
        createdAt: Value(createdAt),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<QuranReadingState> getOrCreateReadingState() async {
    final row = await (select(quranReadingStates)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (row != null) return row;

    const companion = QuranReadingStatesCompanion(id: Value(1));
    await into(quranReadingStates).insert(companion, mode: InsertMode.insertOrIgnore);
    return (select(quranReadingStates)..where((t) => t.id.equals(1))).getSingle();
  }

  Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    DateTime? timestamp,
  }) async {
    await getOrCreateReadingState();
    await (update(quranReadingStates)..where((t) => t.id.equals(1))).write(
      QuranReadingStatesCompanion(
        lastSurah: Value(surahNumber),
        lastSurahName: Value(surahName),
        lastAyah: Value(ayahNumber),
        lastReadAt: Value(timestamp ?? DateTime.now()),
      ),
    );
  }

  Future<void> updateWirdState({
    int? dailyCount,
    int? cursorAyah,
    String? completedDate,
    bool clearCompletedDate = false,
    bool? cursorCompleted,
    int? lastBatchEnd,
  }) async {
    await getOrCreateReadingState();
    await (update(quranReadingStates)..where((t) => t.id.equals(1))).write(
      QuranReadingStatesCompanion(
        wirdDailyCount: dailyCount != null ? Value(dailyCount) : const Value.absent(),
        wirdCursorAyah: cursorAyah != null ? Value(cursorAyah) : const Value.absent(),
        wirdCompletedDate: clearCompletedDate
            ? const Value(null)
            : (completedDate != null ? Value(completedDate) : const Value.absent()),
        wirdCursorCompleted:
            cursorCompleted != null ? Value(cursorCompleted) : const Value.absent(),
        wirdLastBatchEnd:
            lastBatchEnd != null ? Value(lastBatchEnd) : const Value.absent(),
      ),
    );
  }
}
