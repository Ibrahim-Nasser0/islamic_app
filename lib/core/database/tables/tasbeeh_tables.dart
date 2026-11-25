import 'package:drift/drift.dart';

/// Persisted counters for each Free Tasbeeh Dhikr phrase.
class TasbeehEntries extends Table {
  TextColumn get id => text()();
  TextColumn get arabicText => text()();
  IntColumn get currentCount => integer().withDefault(const Constant(0))();
  IntColumn get totalCount => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Persisted default and custom Daily Wird items.
class WirdEntries extends Table {
  TextColumn get id => text()();
  TextColumn get arabicText => text()();
  IntColumn get targetCount => integer()();
  IntColumn get currentCount => integer().withDefault(const Constant(0))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Daily worship activity log ready for streaks & analytics UI.
class TasbeehDailyLogs extends Table {
  TextColumn get dateKey => text()();
  IntColumn get tasbeehCount => integer().withDefault(const Constant(0))();
  IntColumn get wirdCompletedCount => integer().withDefault(const Constant(0))();
  BoolColumn get allWirdCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get quranAyahsRead => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {dateKey};
}
