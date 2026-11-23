import 'package:bloc/bloc.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/tasbeeh_defaults.dart';
import '../../domain/entities/tasbeeh_item.dart';
import '../../domain/entities/wird_item.dart';
import 'tasbeeh_state.dart';

/// Cubit managing both free digital tasbeeh and custom structured daily Wird
class TasbeehCubit extends Cubit<TasbeehState> {
  TasbeehCubit()
      : super(const TasbeehState(
          items: TasbeehDefaults.defaultAzkar,
          wirdItems: TasbeehDefaults.defaultWird,
        ));

  void setMode(TasbeehMode mode) {
    AppHaptics.selection();
    emit(state.copyWith(mode: mode));
  }

  // --- Free Tasbeeh Methods ---
  void increment() {
    final current = state.currentItem;
    final newCount = current.currentCount + 1;
    final isTargetReached =
        state.target > 0 && (newCount % state.target == 0);

    if (isTargetReached) {
      AppHaptics.heavy();
    } else {
      AppHaptics.selection();
    }

    final updatedItems = List<TasbeehItem>.from(state.items);
    updatedItems[state.selectedIndex] = current.copyWith(
      currentCount: newCount,
      totalCount: current.totalCount + 1,
    );

    emit(state.copyWith(
      items: updatedItems,
      sessionTotal: state.sessionTotal + 1,
      isTargetReached: isTargetReached,
    ));
  }

  void resetCurrent() {
    AppHaptics.heavy();
    final current = state.currentItem;
    final updatedItems = List<TasbeehItem>.from(state.items);
    updatedItems[state.selectedIndex] = current.copyWith(currentCount: 0);

    emit(state.copyWith(items: updatedItems, isTargetReached: false));
  }

  void setTarget(int target) {
    AppHaptics.selection();
    emit(state.copyWith(target: target));
  }

  void selectDhikr(int index) {
    if (index < 0 || index >= state.items.length) return;
    AppHaptics.selection();
    emit(state.copyWith(selectedIndex: index, isTargetReached: false));
  }

  // --- Daily Wird Methods ---
  void incrementWird() {
    final active = state.activeWirdItem;
    if (active == null) return;

    final newCount = active.currentCount + 1;
    final isCompleted = newCount >= active.targetCount;

    final updated = List<WirdItem>.from(state.wirdItems);
    updated[state.activeWirdIndex] = active.copyWith(currentCount: newCount);

    if (isCompleted) {
      AppHaptics.heavy();
      final allCompleted =
          updated.where((i) => i.isEnabled).every((i) => i.isCompleted);

      int nextIndex = state.activeWirdIndex;
      if (!allCompleted) {
        for (int i = 0; i < updated.length; i++) {
          final candidateIndex = (state.activeWirdIndex + 1 + i) % updated.length;
          if (updated[candidateIndex].isEnabled &&
              !updated[candidateIndex].isCompleted) {
            nextIndex = candidateIndex;
            break;
          }
        }
      }

      emit(state.copyWith(
        wirdItems: updated,
        activeWirdIndex: nextIndex,
        isWirdCompleted: allCompleted,
        sessionTotal: state.sessionTotal + 1,
      ));
    } else {
      AppHaptics.selection();
      emit(state.copyWith(
        wirdItems: updated,
        sessionTotal: state.sessionTotal + 1,
      ));
    }
  }

  void selectWirdItem(int index) {
    if (index < 0 || index >= state.wirdItems.length) return;
    AppHaptics.selection();
    emit(state.copyWith(activeWirdIndex: index));
  }

  void toggleWirdItem(String id, bool enabled) {
    AppHaptics.light();
    final updated = state.wirdItems.map((item) {
      return item.id == id ? item.copyWith(isEnabled: enabled) : item;
    }).toList();
    emit(state.copyWith(wirdItems: updated));
  }

  void updateWirdItemTarget(String id, int target) {
    if (target <= 0) return;
    AppHaptics.selection();
    final updated = state.wirdItems.map((item) {
      return item.id == id ? item.copyWith(targetCount: target) : item;
    }).toList();
    emit(state.copyWith(wirdItems: updated));
  }

  /// Sets all enabled items to a unified target (e.g., 100 for all)
  void setAllTargets(int target) {
    if (target <= 0) return;
    AppHaptics.medium();
    final updated = state.wirdItems.map((item) {
      return item.copyWith(targetCount: target);
    }).toList();
    emit(state.copyWith(wirdItems: updated));
  }

  void addCustomWirdItem(String text, int target) {
    if (text.trim().isEmpty || target <= 0) return;
    AppHaptics.medium();
    final newItem = WirdItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      arabicText: text.trim(),
      targetCount: target,
    );
    final updated = List<WirdItem>.from(state.wirdItems)..add(newItem);
    emit(state.copyWith(wirdItems: updated));
  }

  void removeWirdItem(String id) {
    AppHaptics.heavy();
    final updated = state.wirdItems.where((i) => i.id != id).toList();
    int newIndex = state.activeWirdIndex;
    if (newIndex >= updated.length) {
      newIndex = updated.isEmpty ? 0 : updated.length - 1;
    }
    emit(state.copyWith(wirdItems: updated, activeWirdIndex: newIndex));
  }

  void resetWird() {
    AppHaptics.heavy();
    final updated = state.wirdItems.map((item) {
      return item.copyWith(currentCount: 0);
    }).toList();
    emit(state.copyWith(
      wirdItems: updated,
      activeWirdIndex: 0,
      isWirdCompleted: false,
    ));
  }
}
