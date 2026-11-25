// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_dao.dart';

// ignore_for_file: type=lint
mixin _$QuranDaoMixin on DatabaseAccessor<AppDatabase> {
  $QuranBookmarksTable get quranBookmarks => attachedDatabase.quranBookmarks;
  $QuranReadingStatesTable get quranReadingStates =>
      attachedDatabase.quranReadingStates;
  QuranDaoManager get managers => QuranDaoManager(this);
}

class QuranDaoManager {
  final _$QuranDaoMixin _db;
  QuranDaoManager(this._db);
  $$QuranBookmarksTableTableManager get quranBookmarks =>
      $$QuranBookmarksTableTableManager(
        _db.attachedDatabase,
        _db.quranBookmarks,
      );
  $$QuranReadingStatesTableTableManager get quranReadingStates =>
      $$QuranReadingStatesTableTableManager(
        _db.attachedDatabase,
        _db.quranReadingStates,
      );
}
