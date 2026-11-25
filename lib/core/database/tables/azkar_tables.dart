import 'package:drift/drift.dart';

/// Persisted remaining repetition counts for Azkar categories & native lockscreen sync.
class AzkarProgressEntries extends Table {
  TextColumn get categoryId => text()();
  TextColumn get dhikrId => text()();
  IntColumn get remainingCount => integer()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {categoryId, dhikrId};
}
