import 'package:drift/drift.dart';

/// Metadata for each canonical Hadith collection stored inside the prebuilt catalog.
@DataClassName('HadithBookRow')
class HadithBooks extends Table {
  TextColumn get id => text()();
  TextColumn get titleAr => text()();
  TextColumn get titleEn => text()();
  IntColumn get totalCount => integer()();
  TextColumn get defaultGradeAr => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Full indexed Hadith catalog table synchronized 1-to-1 with `tool/build_hadith_db.py`.
@TableIndex(
  name: 'idx_hadiths_book_num',
  columns: {#bookId, #number},
  unique: true,
)
@TableIndex(
  name: 'idx_hadiths_grade',
  columns: {#bookId, #gradeTier},
)
@TableIndex(
  name: 'idx_hadiths_daily_pool',
  columns: {#gradeTier, #textLength},
)
@DataClassName('HadithCatalogRow')
class Hadiths extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookId => text()();
  IntColumn get number => integer()();
  TextColumn get chapterAr => text()();
  TextColumn get titleAr => text()();
  TextColumn get arabicText => text()();
  TextColumn get narrator => text()();
  TextColumn get reference => text()();
  TextColumn get benefit => text().nullable()();
  TextColumn get gradeTier => text()();
  TextColumn get gradeLabelAr => text()();
  TextColumn get gradeLabelEn => text()();
  IntColumn get strengthScore => integer()();
  IntColumn get textLength => integer()();
}
