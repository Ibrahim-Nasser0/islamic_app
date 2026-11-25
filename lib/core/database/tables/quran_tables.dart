import 'package:drift/drift.dart';

/// Saved Mushaf bookmarks with unique surah + ayah constraint.
@DataClassName('QuranBookmarkRow')
class QuranBookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  TextColumn get surahName => text()();
  IntColumn get ayahNumber => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {surahNumber, ayahNumber},
      ];
}

/// Singleton row tracking Mushaf last-read & sequential Daily Quran Wird cursor.
class QuranReadingStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get lastSurah => integer().withDefault(const Constant(18))();
  TextColumn get lastSurahName => text().withDefault(const Constant('الكهف'))();
  IntColumn get lastAyah => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastReadAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get wirdDailyCount => integer().withDefault(const Constant(5))();
  IntColumn get wirdCursorAyah => integer().withDefault(const Constant(1))();
  TextColumn get wirdCompletedDate => text().nullable()();
  BoolColumn get wirdCursorCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get wirdLastBatchEnd => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
