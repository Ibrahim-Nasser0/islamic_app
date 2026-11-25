import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/tasbeeh_dao.dart';
import '../../domain/entities/tasbeeh_defaults.dart';
import '../../domain/entities/tasbeeh_item.dart';
import '../../domain/entities/wird_item.dart';
import 'tasbeeh_local_data_source.dart';

/// Helper functions for legacy JSON decoding and Drift synchronization.
class TasbeehPersistenceMapper {
  const TasbeehPersistenceMapper._();

  static List<TasbeehItem> decodeLegacyFreeItems(String? raw) {
    if (raw == null || raw.isEmpty) return TasbeehDefaults.defaultAzkar;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return TasbeehDefaults.defaultAzkar.map((item) {
        final entry = decoded[item.id] as Map<String, dynamic>?;
        if (entry == null) return item;
        return item.copyWith(
          currentCount: (entry['current'] as num?)?.toInt() ?? 0,
          totalCount: (entry['total'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (_) {
      return TasbeehDefaults.defaultAzkar;
    }
  }

  static List<WirdItem> decodeLegacyWirdItems(
    String? raw, {
    required bool resetProgress,
  }) {
    if (raw == null || raw.isEmpty) return TasbeehDefaults.defaultWird;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) {
        final m = e as Map<String, dynamic>;
        return WirdItem(
          id: m['id'] as String,
          arabicText: m['arabicText'] as String,
          targetCount: (m['targetCount'] as num).toInt(),
          currentCount:
              resetProgress ? 0 : (m['currentCount'] as num?)?.toInt() ?? 0,
          isEnabled: m['isEnabled'] as bool? ?? true,
        );
      }).toList();
    } catch (_) {
      return TasbeehDefaults.defaultWird;
    }
  }

  static List<TasbeehItem> mergeEntriesWithDefaults(List<TasbeehEntry> entries) {
    final byId = {for (final e in entries) e.id: e};
    return TasbeehDefaults.defaultAzkar.map((item) {
      final row = byId[item.id];
      return row == null
          ? item
          : item.copyWith(currentCount: row.currentCount, totalCount: row.totalCount);
    }).toList();
  }

  static Future<void> persistToDrift(
    TasbeehDao dao,
    TasbeehSnapshot snapshot,
    String today,
    int delta,
  ) async {
    final defaultIds = TasbeehDefaults.defaultWird.map((w) => w.id).toSet();
    final tasbeehRows = <TasbeehEntriesCompanion>[
      for (var i = 0; i < snapshot.items.length; i++)
        TasbeehEntriesCompanion.insert(
          id: snapshot.items[i].id,
          arabicText: snapshot.items[i].arabicText,
          currentCount: Value(snapshot.items[i].currentCount),
          totalCount: Value(snapshot.items[i].totalCount),
          sortOrder: Value(i),
        ),
    ];
    final wirdRows = <WirdEntriesCompanion>[
      for (var i = 0; i < snapshot.wirdItems.length; i++)
        WirdEntriesCompanion.insert(
          id: snapshot.wirdItems[i].id,
          arabicText: snapshot.wirdItems[i].arabicText,
          targetCount: snapshot.wirdItems[i].targetCount,
          currentCount: Value(snapshot.wirdItems[i].currentCount),
          isEnabled: Value(snapshot.wirdItems[i].isEnabled),
          isCustom: Value(!defaultIds.contains(snapshot.wirdItems[i].id)),
          sortOrder: Value(i),
        ),
    ];
    final enabledWirds = snapshot.wirdItems.where((w) => w.isEnabled).toList();
    final completedWirds = enabledWirds.where((w) => w.isCompleted).length;
    await dao.upsertTasbeehEntries(tasbeehRows);
    await dao.replaceWirdEntries(wirdRows);
    await dao.recordDailyLog(
      dateKey: today,
      tasbeehDelta: delta > 0 ? delta : null,
      wirdCompletedCount: completedWirds,
      allWirdCompleted:
          enabledWirds.isNotEmpty && completedWirds == enabledWirds.length,
    );
  }
}
