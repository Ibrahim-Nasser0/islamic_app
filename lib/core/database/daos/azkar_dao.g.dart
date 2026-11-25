// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azkar_dao.dart';

// ignore_for_file: type=lint
mixin _$AzkarDaoMixin on DatabaseAccessor<AppDatabase> {
  $AzkarProgressEntriesTable get azkarProgressEntries =>
      attachedDatabase.azkarProgressEntries;
  AzkarDaoManager get managers => AzkarDaoManager(this);
}

class AzkarDaoManager {
  final _$AzkarDaoMixin _db;
  AzkarDaoManager(this._db);
  $$AzkarProgressEntriesTableTableManager get azkarProgressEntries =>
      $$AzkarProgressEntriesTableTableManager(
        _db.attachedDatabase,
        _db.azkarProgressEntries,
      );
}
