import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/azkar_dao.dart';
import 'daos/quran_dao.dart';
import 'daos/tasbeeh_dao.dart';
import 'tables/azkar_tables.dart';
import 'tables/quran_tables.dart';
import 'tables/tasbeeh_tables.dart';

part 'app_database.g.dart';

/// Central Drift SQLite database for Zad Al-Muslim structured user data.
@DriftDatabase(
  tables: [
    TasbeehEntries,
    WirdEntries,
    TasbeehDailyLogs,
    QuranBookmarks,
    QuranReadingStates,
    AzkarProgressEntries,
  ],
  daos: [TasbeehDao, QuranDao, AzkarDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'zad_al_muslim_db'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(quranReadingStates).insert(
            const QuranReadingStatesCompanion(id: Value(1)),
            mode: InsertMode.insertOrIgnore,
          );
        },
      );
}
