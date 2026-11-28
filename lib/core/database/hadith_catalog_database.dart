import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'daos/hadith_dao.dart';
import 'tables/hadith_catalog_tables.dart';

part 'hadith_catalog_database.g.dart';

/// Dedicated Drift database wrapping the pre-indexed, FTS5-enabled
/// 16,674-Hadith catalog (`assets/hadith/hadith_catalog.db.gz`), kept strictly
/// separate from user state in [AppDatabase].
@DriftDatabase(tables: [HadithBooks, Hadiths], daos: [HadithDao])
class HadithCatalogDatabase extends _$HadithCatalogDatabase {
  static const String catalogAssetPath = 'assets/hadith/hadith_catalog.db.gz';
  static const String catalogFileName = 'hadith_catalog_v1.db';

  HadithCatalogDatabase() : super(_openCatalogConnection());

  HadithCatalogDatabase.fromFile(File dbFile)
      : super(NativeDatabase.createInBackground(dbFile));

  HadithCatalogDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          final existing = await customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='hadiths'",
          ).get();
          if (existing.isEmpty) {
            await m.createAll();
          }
          await customStatement('''
            CREATE VIRTUAL TABLE IF NOT EXISTS hadiths_fts USING fts5(
              search_normalized,
              content='',
              detail='none',
              tokenize='unicode61'
            )
          ''');
        },
      );
}

LazyDatabase _openCatalogConnection() {
  return LazyDatabase(() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final targetFile = File(
      '${docsDir.path}${Platform.pathSeparator}${HadithCatalogDatabase.catalogFileName}',
    );
    if (!await targetFile.exists() || await targetFile.length() == 0) {
      await _extractCompressedCatalog(targetFile);
    }
    return NativeDatabase.createInBackground(targetFile);
  });
}

Future<void> _extractCompressedCatalog(File targetFile) async {
  final tmpFile = File('${targetFile.path}.tmp');
  try {
    final byteData = await rootBundle.load(
      HadithCatalogDatabase.catalogAssetPath,
    );
    final compressed = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
    final rawBytes = await compute(_decodeGzipBytes, compressed);
    await tmpFile.parent.create(recursive: true);
    await tmpFile.writeAsBytes(rawBytes, flush: true);
    await tmpFile.rename(targetFile.path);
    debugPrint(
      '[HadithCatalogDatabase] Extracted catalog DB (${rawBytes.length} bytes) to ${targetFile.path}',
    );
  } catch (e, stackTrace) {
    debugPrint(
      '[HadithCatalogDatabase] Failed to extract catalog DB: $e\n$stackTrace',
    );
    try {
      if (await tmpFile.exists()) {
        await tmpFile.delete();
      }
    } catch (cleanupError) {
      // Non-critical cleanup of temporary extraction file.
      debugPrint(
        '[HadithCatalogDatabase] Failed to remove temp DB file: $cleanupError',
      );
    }
    rethrow;
  }
}

Uint8List _decodeGzipBytes(Uint8List compressed) =>
    Uint8List.fromList(gzip.decode(compressed));
