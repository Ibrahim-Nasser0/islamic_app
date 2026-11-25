import '../../data/datasources/tasbeeh_local_data_source.dart';
import '../../domain/entities/tasbeeh_defaults.dart';
import '../../domain/entities/wird_item.dart';
import 'tasbeeh_state.dart';

/// Pure helper functions for Daily Wird state calculations and mutations.
class TasbeehWirdHelpers {
  const TasbeehWirdHelpers._();

  static TasbeehState buildInitialState(TasbeehLocalDataSource? localDs) {
    if (localDs == null) {
      return const TasbeehState(
        items: TasbeehDefaults.defaultAzkar,
        wirdItems: TasbeehDefaults.defaultWird,
      );
    }
    final snap = localDs.loadSnapshot();
    return TasbeehState(
      items: snap.items,
      selectedIndex: snap.selectedIndex,
      target: snap.target,
      lifetimeTotal: snap.lifetimeTotal,
      feedbackMode: snap.feedbackMode,
      wirdItems: snap.wirdItems,
      activeWirdIndex: snap.activeWirdIndex,
      isWirdCompleted: areAllEnabledDone(snap.wirdItems),
    );
  }

  static TasbeehSnapshot toSnapshot(TasbeehState next) => TasbeehSnapshot(
        selectedIndex: next.selectedIndex,
        target: next.target,
        lifetimeTotal: next.lifetimeTotal,
        feedbackMode: next.feedbackMode,
        items: next.items,
        wirdItems: next.wirdItems,
        activeWirdIndex: next.activeWirdIndex,
      );

  static bool areAllEnabledDone(List<WirdItem> items) {
    final enabled = items.where((i) => i.isEnabled).toList();
    return enabled.isNotEmpty && enabled.every((i) => i.isCompleted);
  }

  static int resolveNextWirdIndex(List<WirdItem> items, int currentIdx) {
    if (items.isEmpty) return 0;
    if (currentIdx >= 0 &&
        currentIdx < items.length &&
        items[currentIdx].isEnabled &&
        !items[currentIdx].isCompleted) {
      return currentIdx;
    }
    for (var i = 1; i <= items.length; i++) {
      final candidate = (currentIdx + i) % items.length;
      if (items[candidate].isEnabled && !items[candidate].isCompleted) {
        return candidate;
      }
    }
    final firstEnabled = items.indexWhere((i) => i.isEnabled);
    return firstEnabled >= 0 ? firstEnabled : 0;
  }

  static List<WirdItem> toggleItem(
    List<WirdItem> items,
    String id,
    bool enabled,
  ) =>
      items.map((i) => i.id == id ? i.copyWith(isEnabled: enabled) : i).toList();

  static List<WirdItem> updateTarget(
    List<WirdItem> items,
    String id,
    int target,
  ) =>
      items
          .map((i) => i.id == id ? i.copyWith(targetCount: target) : i)
          .toList();

  static List<WirdItem> setAllTargets(List<WirdItem> items, int target) =>
      items.map((i) => i.copyWith(targetCount: target)).toList();

  static List<WirdItem> addCustom(
    List<WirdItem> items,
    String text,
    int target,
  ) =>
      List<WirdItem>.from(items)
        ..add(WirdItem(
          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
          arabicText: text.trim(),
          targetCount: target,
        ));
}
