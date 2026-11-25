// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbeeh_dao.dart';

// ignore_for_file: type=lint
mixin _$TasbeehDaoMixin on DatabaseAccessor<AppDatabase> {
  $TasbeehEntriesTable get tasbeehEntries => attachedDatabase.tasbeehEntries;
  $WirdEntriesTable get wirdEntries => attachedDatabase.wirdEntries;
  $TasbeehDailyLogsTable get tasbeehDailyLogs =>
      attachedDatabase.tasbeehDailyLogs;
  TasbeehDaoManager get managers => TasbeehDaoManager(this);
}

class TasbeehDaoManager {
  final _$TasbeehDaoMixin _db;
  TasbeehDaoManager(this._db);
  $$TasbeehEntriesTableTableManager get tasbeehEntries =>
      $$TasbeehEntriesTableTableManager(
        _db.attachedDatabase,
        _db.tasbeehEntries,
      );
  $$WirdEntriesTableTableManager get wirdEntries =>
      $$WirdEntriesTableTableManager(_db.attachedDatabase, _db.wirdEntries);
  $$TasbeehDailyLogsTableTableManager get tasbeehDailyLogs =>
      $$TasbeehDailyLogsTableTableManager(
        _db.attachedDatabase,
        _db.tasbeehDailyLogs,
      );
}
