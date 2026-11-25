import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/tasbeeh_defaults.dart';
import '../../domain/entities/tasbeeh_feedback_mode.dart';
import '../../domain/entities/tasbeeh_item.dart';
import '../../domain/entities/wird_item.dart';

/// Persisted snapshot of Tasbeeh counters, preferences, and Daily Wird progress.
class TasbeehSnapshot {
  final int selectedIndex;
  final int target;
  final int lifetimeTotal;
  final TasbeehFeedbackMode feedbackMode;
  final List<TasbeehItem> items;
  final List<WirdItem> wirdItems;
  final int activeWirdIndex;

  const TasbeehSnapshot({
    required this.selectedIndex,
    required this.target,
    required this.lifetimeTotal,
    required this.feedbackMode,
    required this.items,
    required this.wirdItems,
    required this.activeWirdIndex,
  });
}

/// Contract for local persistence of Smart Tasbeeh and Daily Wird state.
abstract class TasbeehLocalDataSource {
  TasbeehSnapshot loadSnapshot({DateTime? now});
  Future<void> saveSnapshot(TasbeehSnapshot snapshot, {DateTime? now});
}

class TasbeehLocalDataSourceImpl implements TasbeehLocalDataSource {
  final SharedPreferences _prefs;

  static const String _kSelectedIndex = 'tasbeeh_selected_index';
  static const String _kTarget = 'tasbeeh_target';
  static const String _kLifetimeTotal = 'tasbeeh_lifetime_total';
  static const String _kFeedbackMode = 'tasbeeh_feedback_mode';
  static const String _kFreeCounts = 'tasbeeh_free_counts';
  static const String _kWirdItems = 'tasbeeh_wird_items';
  static const String _kActiveWirdIdx = 'tasbeeh_active_wird_idx';
  static const String _kWirdDate = 'tasbeeh_wird_date';

  const TasbeehLocalDataSourceImpl(this._prefs);

  String _dateKey(DateTime now) =>
      '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';

  @override
  TasbeehSnapshot loadSnapshot({DateTime? now}) {
    final today = _dateKey(now ?? DateTime.now());
    final savedDate = _prefs.getString(_kWirdDate);
    final isNewDay = savedDate != null && savedDate != today;

    final selectedIndex = (_prefs.getInt(_kSelectedIndex) ?? 0)
        .clamp(0, TasbeehDefaults.defaultAzkar.length - 1);
    final target = _prefs.getInt(_kTarget) ?? 33;
    final lifetimeTotal = _prefs.getInt(_kLifetimeTotal) ?? 0;

    final modeIndex = (_prefs.getInt(_kFeedbackMode) ?? 0)
        .clamp(0, TasbeehFeedbackMode.values.length - 1);
    final feedbackMode = TasbeehFeedbackMode.values[modeIndex];

    final items = _loadFreeItems();
    final wirdItems = _loadWirdItems(resetProgress: isNewDay);
    final rawWirdIdx = isNewDay ? 0 : (_prefs.getInt(_kActiveWirdIdx) ?? 0);
    final activeWirdIndex = wirdItems.isEmpty
        ? 0
        : rawWirdIdx.clamp(0, wirdItems.length - 1);

    if (isNewDay || savedDate == null) {
      _prefs.setString(_kWirdDate, today);
    }

    return TasbeehSnapshot(
      selectedIndex: selectedIndex,
      target: target,
      lifetimeTotal: lifetimeTotal,
      feedbackMode: feedbackMode,
      items: items,
      wirdItems: wirdItems,
      activeWirdIndex: activeWirdIndex,
    );
  }

  List<TasbeehItem> _loadFreeItems() {
    final raw = _prefs.getString(_kFreeCounts);
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

  List<WirdItem> _loadWirdItems({required bool resetProgress}) {
    final raw = _prefs.getString(_kWirdItems);
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

  @override
  Future<void> saveSnapshot(TasbeehSnapshot snapshot, {DateTime? now}) async {
    final today = _dateKey(now ?? DateTime.now());
    final countsMap = {
      for (final item in snapshot.items)
        item.id: {'current': item.currentCount, 'total': item.totalCount},
    };
    final wirdList = snapshot.wirdItems
        .map((w) => {
              'id': w.id,
              'arabicText': w.arabicText,
              'targetCount': w.targetCount,
              'currentCount': w.currentCount,
              'isEnabled': w.isEnabled,
            })
        .toList();

    await Future.wait([
      _prefs.setInt(_kSelectedIndex, snapshot.selectedIndex),
      _prefs.setInt(_kTarget, snapshot.target),
      _prefs.setInt(_kLifetimeTotal, snapshot.lifetimeTotal),
      _prefs.setInt(_kFeedbackMode, snapshot.feedbackMode.index),
      _prefs.setString(_kFreeCounts, jsonEncode(countsMap)),
      _prefs.setString(_kWirdItems, jsonEncode(wirdList)),
      _prefs.setInt(_kActiveWirdIdx, snapshot.activeWirdIndex),
      _prefs.setString(_kWirdDate, today),
    ]);
  }
}
