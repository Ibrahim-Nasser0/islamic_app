import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/haptics.dart';
import '../../data/datasources/tasbeeh_local_data_source.dart';
import '../../domain/entities/tasbeeh_feedback_mode.dart';
import '../../domain/entities/tasbeeh_item.dart';
import '../../domain/entities/wird_item.dart';
import 'tasbeeh_state.dart';
import 'tasbeeh_wird_helpers.dart';

/// Cubit managing Free Tasbeeh, Daily Wird, feedback modes, and persistence.
class TasbeehCubit extends Cubit<TasbeehState> {
  final TasbeehLocalDataSource? _localDs;
  Future<void> _pendingSave = Future.value();

  TasbeehCubit({TasbeehLocalDataSource? localDs})
      : _localDs = localDs,
        super(TasbeehWirdHelpers.buildInitialState(localDs));

  void _emitAndSave(TasbeehState next) {
    emit(next);
    final ds = _localDs;
    if (ds != null) {
      final snapshot = TasbeehWirdHelpers.toSnapshot(next);
      _pendingSave = _pendingSave.then((_) => ds.saveSnapshot(snapshot));
    }
  }

  @override
  Future<void> close() async {
    await _pendingSave;
    return super.close();
  }

  void _playFeedback({bool milestone = false}) {
    if (state.feedbackMode == TasbeehFeedbackMode.silent) return;
    milestone ? AppHaptics.heavy() : AppHaptics.selection();
    if (state.feedbackMode == TasbeehFeedbackMode.soundAndHaptic) {
      try {
        SystemSound.play(SystemSoundType.click);
      } catch (e) {
        // Non-critical: System click sound may fail on unsupported hardware
        debugPrint('Tasbeeh click sound failed: $e');
      }
    }
  }

  void setMode(TasbeehMode mode) {
    AppHaptics.selection();
    emit(state.copyWith(mode: mode));
  }

  void cycleFeedbackMode() {
    final next = state.feedbackMode.next();
    if (next != TasbeehFeedbackMode.silent) AppHaptics.light();
    _emitAndSave(state.copyWith(feedbackMode: next));
  }

  void increment() {
    final current = state.currentItem;
    final newCount = current.currentCount + 1;
    final milestone = state.target > 0 && (newCount % state.target == 0);
    _playFeedback(milestone: milestone);
    final updated = List<TasbeehItem>.from(state.items);
    updated[state.selectedIndex] =
        current.copyWith(currentCount: newCount, totalCount: current.totalCount + 1);
    _emitAndSave(state.copyWith(
      items: updated,
      sessionTotal: state.sessionTotal + 1,
      lifetimeTotal: state.lifetimeTotal + 1,
      isTargetReached: milestone,
    ));
  }

  /// Steps back 1 count to correct accidental double-taps.
  void decrement() {
    final current = state.currentItem;
    if (current.currentCount <= 0) return;
    _playFeedback();
    final updated = List<TasbeehItem>.from(state.items);
    final count = (current.currentCount - 1).clamp(0, 1 << 30);
    updated[state.selectedIndex] = current.copyWith(currentCount: count, totalCount: (current.totalCount - 1).clamp(0, 1 << 30));
    final prevSession = (state.sessionTotal - 1).clamp(0, 1 << 30);
    _emitAndSave(state.copyWith(items: updated, sessionTotal: prevSession, lifetimeTotal: (state.lifetimeTotal - 1).clamp(0, 1 << 30), isTargetReached: false));
  }

  void resetCurrent() {
    if (state.feedbackMode != TasbeehFeedbackMode.silent) AppHaptics.heavy();
    final updated = List<TasbeehItem>.from(state.items);
    updated[state.selectedIndex] = state.currentItem.copyWith(currentCount: 0);
    _emitAndSave(state.copyWith(items: updated, isTargetReached: false));
  }

  void setTarget(int target) {
    AppHaptics.selection();
    _emitAndSave(state.copyWith(target: target, isTargetReached: false));
  }

  void selectDhikr(int index) {
    if (index < 0 || index >= state.items.length) return;
    AppHaptics.selection();
    _emitAndSave(state.copyWith(selectedIndex: index, isTargetReached: false));
  }

  void incrementWird() {
    final active = state.activeWirdItem;
    if (active == null) return;
    final activeIdx = state.wirdItems.indexOf(active);
    if (activeIdx < 0) return;

    final newCount = active.currentCount + 1;
    final itemDone = newCount >= active.targetCount;
    _playFeedback(milestone: itemDone);

    final updated = List<WirdItem>.from(state.wirdItems);
    updated[activeIdx] = active.copyWith(currentCount: newCount);
    final allDone = TasbeehWirdHelpers.areAllEnabledDone(updated);
    final nextIndex = itemDone && !allDone
        ? TasbeehWirdHelpers.resolveNextWirdIndex(updated, activeIdx)
        : activeIdx;
    _emitAndSave(state.copyWith(
      wirdItems: updated,
      activeWirdIndex: nextIndex,
      isWirdCompleted: allDone,
      sessionTotal: state.sessionTotal + 1,
      lifetimeTotal: state.lifetimeTotal + 1,
    ));
  }

  void decrementWird() {
    final active = state.activeWirdItem;
    if (active == null || active.currentCount <= 0) return;
    final activeIdx = state.wirdItems.indexOf(active);
    if (activeIdx < 0) return;
    _playFeedback();
    final updated = List<WirdItem>.from(state.wirdItems);
    updated[activeIdx] = active.copyWith(currentCount: active.currentCount - 1);
    _emitAndSave(state.copyWith(
      wirdItems: updated,
      isWirdCompleted: false,
      sessionTotal: (state.sessionTotal - 1).clamp(0, 1 << 30),
      lifetimeTotal: (state.lifetimeTotal - 1).clamp(0, 1 << 30),
    ));
  }

  void selectWirdItem(int index) {
    if (index < 0 || index >= state.wirdItems.length) return;
    AppHaptics.selection();
    _emitAndSave(state.copyWith(activeWirdIndex: index));
  }

  void toggleWirdItem(String id, bool enabled) {
    AppHaptics.light();
    _applyWirdMutation(TasbeehWirdHelpers.toggleItem(state.wirdItems, id, enabled));
  }

  void updateWirdItemTarget(String id, int target) {
    if (target <= 0) return;
    AppHaptics.selection();
    _applyWirdMutation(TasbeehWirdHelpers.updateTarget(state.wirdItems, id, target));
  }

  void setAllTargets(int target) {
    if (target <= 0) return;
    AppHaptics.medium();
    _applyWirdMutation(TasbeehWirdHelpers.setAllTargets(state.wirdItems, target));
  }

  void addCustomWirdItem(String text, int target) {
    if (text.trim().isEmpty || target <= 0) return;
    AppHaptics.medium();
    _applyWirdMutation(TasbeehWirdHelpers.addCustom(state.wirdItems, text, target));
  }

  void removeWirdItem(String id) {
    AppHaptics.heavy();
    _applyWirdMutation(state.wirdItems.where((i) => i.id != id).toList());
  }

  void resetWird() {
    if (state.feedbackMode != TasbeehFeedbackMode.silent) AppHaptics.heavy();
    _applyWirdMutation(state.wirdItems.map((i) => i.copyWith(currentCount: 0)).toList(), resetCursor: true);
  }

  void _applyWirdMutation(List<WirdItem> updated, {bool resetCursor = false}) {
    final maxIdx = updated.isEmpty ? 0 : updated.length - 1;
    final seed = resetCursor ? 0 : state.activeWirdIndex.clamp(0, maxIdx);
    _emitAndSave(state.copyWith(
      wirdItems: updated,
      activeWirdIndex: TasbeehWirdHelpers.resolveNextWirdIndex(updated, seed),
      isWirdCompleted: TasbeehWirdHelpers.areAllEnabledDone(updated),
    ));
  }
}
