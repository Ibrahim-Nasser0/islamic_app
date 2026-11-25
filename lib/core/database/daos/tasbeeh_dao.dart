import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tasbeeh_tables.dart';

part 'tasbeeh_dao.g.dart';

@DriftAccessor(tables: [TasbeehEntries, WirdEntries, TasbeehDailyLogs])
class TasbeehDao extends DatabaseAccessor<AppDatabase> with _$TasbeehDaoMixin {
  TasbeehDao(super.db);

  Future<List<TasbeehEntry>> getAllTasbeehEntries() =>
      (select(tasbeehEntries)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<void> upsertTasbeehEntries(List<TasbeehEntriesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(tasbeehEntries, rows));
  }

  Future<List<WirdEntry>> getAllWirdEntries() =>
      (select(wirdEntries)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<void> replaceWirdEntries(List<WirdEntriesCompanion> rows) async {
    await transaction(() async {
      await delete(wirdEntries).go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(wirdEntries, rows));
      }
    });
  }

  Future<void> resetWirdDailyProgress() => update(wirdEntries).write(
        const WirdEntriesCompanion(currentCount: Value(0)),
      );

  Future<void> recordDailyLog({
    required String dateKey,
    int? tasbeehDelta,
    int? wirdCompletedCount,
    bool? allWirdCompleted,
    int? quranAyahsDelta,
  }) async {
    await transaction(() async {
      final existing = await (select(tasbeehDailyLogs)
            ..where((t) => t.dateKey.equals(dateKey)))
          .getSingleOrNull();
      final nextTasbeeh =
          ((existing?.tasbeehCount ?? 0) + (tasbeehDelta ?? 0)).clamp(0, 1 << 30);
      final nextQuran =
          ((existing?.quranAyahsRead ?? 0) + (quranAyahsDelta ?? 0))
              .clamp(0, 1 << 30);

      await into(tasbeehDailyLogs).insertOnConflictUpdate(
        TasbeehDailyLogsCompanion(
          dateKey: Value(dateKey),
          tasbeehCount: Value(nextTasbeeh),
          wirdCompletedCount:
              Value(wirdCompletedCount ?? existing?.wirdCompletedCount ?? 0),
          allWirdCompleted:
              Value(allWirdCompleted ?? existing?.allWirdCompleted ?? false),
          quranAyahsRead: Value(nextQuran),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<List<TasbeehDailyLog>> getRecentLogs({int limit = 30}) =>
      (select(tasbeehDailyLogs)
            ..orderBy([(t) => OrderingTerm.desc(t.dateKey)])
            ..limit(limit))
          .get();

  Future<TasbeehDailyLog?> getLogForDate(String dateKey) =>
      (select(tasbeehDailyLogs)..where((t) => t.dateKey.equals(dateKey)))
          .getSingleOrNull();
}
