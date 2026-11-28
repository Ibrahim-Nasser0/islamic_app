// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_dao.dart';

// ignore_for_file: type=lint
mixin _$HadithDaoMixin on DatabaseAccessor<HadithCatalogDatabase> {
  $HadithBooksTable get hadithBooks => attachedDatabase.hadithBooks;
  $HadithsTable get hadiths => attachedDatabase.hadiths;
  HadithDaoManager get managers => HadithDaoManager(this);
}

class HadithDaoManager {
  final _$HadithDaoMixin _db;
  HadithDaoManager(this._db);
  $$HadithBooksTableTableManager get hadithBooks =>
      $$HadithBooksTableTableManager(_db.attachedDatabase, _db.hadithBooks);
  $$HadithsTableTableManager get hadiths =>
      $$HadithsTableTableManager(_db.attachedDatabase, _db.hadiths);
}
