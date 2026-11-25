import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/daos/tasbeeh_dao.dart';
import '../../domain/entities/tasbeeh_defaults.dart';
import '../../domain/entities/tasbeeh_feedback_mode.dart';
import '../../domain/entities/tasbeeh_item.dart';
import '../../domain/entities/wird_item.dart';
import 'tasbeeh_persistence_mapper.dart';

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
  final TasbeehDao? _dao;

  List<TasbeehItem>? _cachedFreeItems;
  List<WirdItem>? _cachedWirdItems;
  int? _lastLoggedLifetimeTotal;

  static const String _kSelectedIndex = 'tasbeeh_selected_index';
  static const String _kTarget = 'tasbeeh_target';
  static const String _kLifetimeTotal = 'tasbeeh_lifetime_total';
  static const String _kFeedbackMode = 'tasbeeh_feedback_mode';
  static const String _kFreeCounts = 'tasbeeh_free_counts';
  static const String _kWirdItems = 'tasbeeh_wird_items';
  static const String _kActiveWirdIdx = 'tasbeeh_active_wird_idx';
  static const String _kWirdDate = 'tasbeeh_wird_date';

  TasbeehLocalDataSourceImpl(this._prefs, {TasbeehDao? tasbeehDao})
      : _dao = tasbeehDao;

  String _dateKey(DateTime now) =>
      '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';

  /// Preloads Drift tables into memory so [loadSnapshot] stays synchronous.
  Future<void> warmUp({DateTime? now}) async {
    final dao = _dao;
    if (dao == null) return;
    final today = _dateKey(now ?? DateTime.now());
    final savedDate = _prefs.getString(_kWirdDate);
    final isNewDay = savedDate != null && savedDate != today;

    final entries = await dao.getAllTasbeehEntries();
    _cachedFreeItems = entries.isNotEmpty
        ? TasbeehPersistenceMapper.mergeEntriesWithDefaults(entries)
        : TasbeehPersistenceMapper.decodeLegacyFreeItems(
            _prefs.getString(_kFreeCounts),
          );

    if (isNewDay) {
      await dao.resetWirdDailyProgress();
      await _prefs.setString(_kWirdDate, today);
      await _prefs.setInt(_kActiveWirdIdx, 0);
    }

    final wirdRows = await dao.getAllWirdEntries();
    _cachedWirdItems = wirdRows.isNotEmpty
        ? wirdRows
            .map(
              (r) => WirdItem(
                id: r.id,
                arabicText: r.arabicText,
                targetCount: r.targetCount,
                currentCount: isNewDay ? 0 : r.currentCount,
                isEnabled: r.isEnabled,
              ),
            )
            .toList()
        : TasbeehPersistenceMapper.decodeLegacyWirdItems(
            _prefs.getString(_kWirdItems),
            resetProgress: isNewDay,
          );
    _lastLoggedLifetimeTotal ??= _prefs.getInt(_kLifetimeTotal) ?? 0;
  }

  @override
  TasbeehSnapshot loadSnapshot({DateTime? now}) {
    final today = _dateKey(now ?? DateTime.now());
    final savedDate = _prefs.getString(_kWirdDate);
    final isNewDay = savedDate != null && savedDate != today;

    final selectedIndex = (_prefs.getInt(_kSelectedIndex) ?? 0)
        .clamp(0, TasbeehDefaults.defaultAzkar.length - 1);
    final target = _prefs.getInt(_kTarget) ?? 33;
    final lifetimeTotal = _prefs.getInt(_kLifetimeTotal) ?? 0;
    _lastLoggedLifetimeTotal ??= lifetimeTotal;

    final modeIndex = (_prefs.getInt(_kFeedbackMode) ?? 0)
        .clamp(0, TasbeehFeedbackMode.values.length - 1);

    final items = _cachedFreeItems ??
        TasbeehPersistenceMapper.decodeLegacyFreeItems(
          _prefs.getString(_kFreeCounts),
        );
    var wirdItems = _cachedWirdItems ??
        TasbeehPersistenceMapper.decodeLegacyWirdItems(
          _prefs.getString(_kWirdItems),
          resetProgress: isNewDay,
        );
    if (isNewDay && _cachedWirdItems != null) {
      wirdItems = wirdItems.map((w) => w.copyWith(currentCount: 0)).toList();
      _cachedWirdItems = wirdItems;
      _dao?.resetWirdDailyProgress();
    }

    final rawWirdIdx = isNewDay ? 0 : (_prefs.getInt(_kActiveWirdIdx) ?? 0);
    final activeWirdIndex =
        wirdItems.isEmpty ? 0 : rawWirdIdx.clamp(0, wirdItems.length - 1);

    if (isNewDay || savedDate == null) _prefs.setString(_kWirdDate, today);

    return TasbeehSnapshot(
      selectedIndex: selectedIndex,
      target: target,
      lifetimeTotal: lifetimeTotal,
      feedbackMode: TasbeehFeedbackMode.values[modeIndex],
      items: items,
      wirdItems: wirdItems,
      activeWirdIndex: activeWirdIndex,
    );
  }

  @override
  Future<void> saveSnapshot(TasbeehSnapshot snapshot, {DateTime? now}) async {
    final today = _dateKey(now ?? DateTime.now());
    final prevTotal =
        _lastLoggedLifetimeTotal ?? (_prefs.getInt(_kLifetimeTotal) ?? 0);
    final delta = (snapshot.lifetimeTotal - prevTotal).clamp(0, 1 << 30);
    _lastLoggedLifetimeTotal = snapshot.lifetimeTotal;
    _cachedFreeItems = snapshot.items;
    _cachedWirdItems = snapshot.wirdItems;

    final futures = <Future<void>>[
      _prefs.setInt(_kSelectedIndex, snapshot.selectedIndex),
      _prefs.setInt(_kTarget, snapshot.target),
      _prefs.setInt(_kLifetimeTotal, snapshot.lifetimeTotal),
      _prefs.setInt(_kFeedbackMode, snapshot.feedbackMode.index),
      _prefs.setInt(_kActiveWirdIdx, snapshot.activeWirdIndex),
      _prefs.setString(_kWirdDate, today),
    ];

    final dao = _dao;
    if (dao != null) {
      futures.add(
        TasbeehPersistenceMapper.persistToDrift(dao, snapshot, today, delta),
      );
    } else {
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
      futures.add(_prefs.setString(_kFreeCounts, jsonEncode(countsMap)));
      futures.add(_prefs.setString(_kWirdItems, jsonEncode(wirdList)));
    }
    await Future.wait(futures);
  }
}
