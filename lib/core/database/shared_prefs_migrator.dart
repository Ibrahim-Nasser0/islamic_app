import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/quran/domain/entities/quran_bookmark.dart';
import '../../features/tasbeeh/domain/entities/tasbeeh_defaults.dart';
import '../utils/constants.dart';
import 'app_database.dart';

/// One-time idempotent migrator from legacy SharedPreferences JSON/int keys to Drift SQLite.
class SharedPrefsToDriftMigrator {
  SharedPrefsToDriftMigrator._();

  static const String migratedFlagKey = 'drift_migrated_v1';

  static const List<String> _knownAzkarCategories = [
    'after_prayer',
    'quranic_duas',
    'morning',
    'evening',
    'sleep',
  ];

  static Future<void> migrateIfNeeded(
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    if (prefs.getBool(migratedFlagKey) == true) return;

    await db.transaction(() async {
      await _migrateTasbeehEntries(db, prefs);
      await _migrateWirdEntries(db, prefs);
      await _migrateQuranData(db, prefs);
      await _migrateAzkarProgress(db, prefs);
    });

    await prefs.setBool(migratedFlagKey, true);
  }

  static Future<void> _migrateTasbeehEntries(
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString('tasbeeh_free_counts');
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final rows = <TasbeehEntriesCompanion>[];
      for (var i = 0; i < TasbeehDefaults.defaultAzkar.length; i++) {
        final item = TasbeehDefaults.defaultAzkar[i];
        final entry = decoded[item.id] as Map<String, dynamic>?;
        rows.add(
          TasbeehEntriesCompanion.insert(
            id: item.id,
            arabicText: item.arabicText,
            currentCount: Value((entry?['current'] as num?)?.toInt() ?? 0),
            totalCount: Value((entry?['total'] as num?)?.toInt() ?? 0),
            sortOrder: Value(i),
          ),
        );
      }
      await db.tasbeehDao.upsertTasbeehEntries(rows);
    } catch (e) {
      debugPrint('SharedPrefsMigrator _migrateTasbeehEntries error: $e');
    }
  }

  static Future<void> _migrateWirdEntries(
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString('tasbeeh_wird_items');
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final defaultIds = TasbeehDefaults.defaultWird.map((w) => w.id).toSet();
      final rows = <WirdEntriesCompanion>[];
      for (var i = 0; i < decoded.length; i++) {
        final m = decoded[i] as Map<String, dynamic>;
        final id = m['id'] as String;
        rows.add(
          WirdEntriesCompanion.insert(
            id: id,
            arabicText: m['arabicText'] as String,
            targetCount: (m['targetCount'] as num).toInt(),
            currentCount: Value((m['currentCount'] as num?)?.toInt() ?? 0),
            isEnabled: Value(m['isEnabled'] as bool? ?? true),
            isCustom: Value(!defaultIds.contains(id)),
            sortOrder: Value(i),
          ),
        );
      }
      await db.tasbeehDao.replaceWirdEntries(rows);
    } catch (e) {
      debugPrint('SharedPrefsMigrator _migrateWirdEntries error: $e');
    }
  }

  static Future<void> _migrateQuranData(
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    final bookmarkList = prefs.getStringList('quran_bookmarks') ?? const [];
    for (final raw in bookmarkList) {
      try {
        final b = QuranBookmark.fromJson(raw);
        await db.quranDao.upsertBookmarkRow(
          surahNumber: b.surahNumber,
          surahName: b.surahName,
          ayahNumber: b.ayahNumber,
          createdAt: b.timestamp,
        );
      } catch (e) {
        debugPrint('SharedPrefsMigrator bookmark migration error: $e');
      }
    }

    final lastReadRaw = prefs.getString('quran_last_read');
    if (lastReadRaw != null && lastReadRaw.isNotEmpty) {
      try {
        final b = QuranBookmark.fromJson(lastReadRaw);
        await db.quranDao.saveLastRead(
          surahNumber: b.surahNumber,
          surahName: b.surahName,
          ayahNumber: b.ayahNumber,
          timestamp: b.timestamp,
        );
      } catch (e) {
        debugPrint('SharedPrefsMigrator lastRead migration error: $e');
      }
    }

    final hasWirdKeys = prefs.containsKey(AppConstants.dailyWirdCountKey) ||
        prefs.containsKey(AppConstants.dailyWirdCursorKey) ||
        prefs.containsKey(AppConstants.dailyWirdCompletedDateKey) ||
        prefs.containsKey(AppConstants.dailyWirdCursorCompletedKey) ||
        prefs.containsKey(AppConstants.dailyWirdLastBatchEndKey);

    if (hasWirdKeys) {
      await db.quranDao.updateWirdState(
        dailyCount: prefs.getInt(AppConstants.dailyWirdCountKey),
        cursorAyah: prefs.getInt(AppConstants.dailyWirdCursorKey),
        completedDate: prefs.getString(AppConstants.dailyWirdCompletedDateKey),
        clearCompletedDate:
            !prefs.containsKey(AppConstants.dailyWirdCompletedDateKey),
        cursorCompleted: prefs.getBool(AppConstants.dailyWirdCursorCompletedKey),
        lastBatchEnd: prefs.getInt(AppConstants.dailyWirdLastBatchEndKey),
      );
    }
  }

  static Future<void> _migrateAzkarProgress(
    AppDatabase db,
    SharedPreferences prefs,
  ) async {
    for (final key in prefs.getKeys()) {
      if (!key.startsWith('dhikr_')) continue;
      final value = prefs.getInt(key);
      if (value == null) continue;
      final parsed = _parseDhikrKey(key.substring('dhikr_'.length));
      if (parsed == null) continue;
      await db.azkarDao.upsertRemaining(
        categoryId: parsed.$1,
        dhikrId: parsed.$2,
        remainingCount: value,
      );
    }
  }

  static (String, String)? _parseDhikrKey(String suffix) {
    for (final catId in _knownAzkarCategories) {
      final prefix = '${catId}_';
      if (suffix.startsWith(prefix) && suffix.length > prefix.length) {
        return (catId, suffix.substring(prefix.length));
      }
    }
    final idx = suffix.indexOf('_');
    if (idx <= 0 || idx >= suffix.length - 1) return null;
    return (suffix.substring(0, idx), suffix.substring(idx + 1));
  }
}
