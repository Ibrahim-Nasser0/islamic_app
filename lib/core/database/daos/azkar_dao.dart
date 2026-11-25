import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/azkar_tables.dart';

part 'azkar_dao.g.dart';

@DriftAccessor(tables: [AzkarProgressEntries])
class AzkarDao extends DatabaseAccessor<AppDatabase> with _$AzkarDaoMixin {
  AzkarDao(super.db);

  Future<Map<String, int>> getRemainingMap(String categoryId) async {
    final rows = await (select(azkarProgressEntries)
          ..where((t) => t.categoryId.equals(categoryId)))
        .get();
    return {for (final r in rows) r.dhikrId: r.remainingCount};
  }

  Future<void> upsertRemaining({
    required String categoryId,
    required String dhikrId,
    required int remainingCount,
  }) async {
    await into(azkarProgressEntries).insertOnConflictUpdate(
      AzkarProgressEntriesCompanion(
        categoryId: Value(categoryId),
        dhikrId: Value(dhikrId),
        remainingCount: Value(remainingCount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> clearCategory(String categoryId) async {
    await (delete(azkarProgressEntries)
          ..where((t) => t.categoryId.equals(categoryId)))
        .go();
  }
}
