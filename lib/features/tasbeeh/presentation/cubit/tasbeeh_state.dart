import 'package:equatable/equatable.dart';
import '../../domain/entities/tasbeeh_feedback_mode.dart';
import '../../domain/entities/tasbeeh_item.dart';
import '../../domain/entities/wird_item.dart';

enum TasbeehMode { free, wird }

class TasbeehState extends Equatable {
  final TasbeehMode mode;
  final List<TasbeehItem> items;
  final int selectedIndex;
  final int target; // 33, 99, 100, or 0 for unlimited
  final int sessionTotal;
  final int lifetimeTotal;
  final TasbeehFeedbackMode feedbackMode;
  final bool isTargetReached;
  final List<WirdItem> wirdItems;
  final int activeWirdIndex;
  final bool isWirdCompleted;

  const TasbeehState({
    this.mode = TasbeehMode.free,
    required this.items,
    this.selectedIndex = 0,
    this.target = 33,
    this.sessionTotal = 0,
    this.lifetimeTotal = 0,
    this.feedbackMode = TasbeehFeedbackMode.haptic,
    this.isTargetReached = false,
    this.wirdItems = const [],
    this.activeWirdIndex = 0,
    this.isWirdCompleted = false,
  });

  TasbeehItem get currentItem => items[selectedIndex];

  /// Count displayed inside the active cycle (shows 33/33 right at milestone).
  int get cycleCount {
    final c = currentItem.currentCount;
    if (target <= 0) return c;
    if (c == 0) return 0;
    final mod = c % target;
    return mod == 0 ? target : mod;
  }

  /// 1-based round number for repeating targets.
  int get currentRound {
    final c = currentItem.currentCount;
    if (target <= 0 || c == 0) return 1;
    return ((c - 1) ~/ target) + 1;
  }

  double get progress {
    if (target <= 0) {
      return currentItem.currentCount == 0
          ? 0.0
          : ((currentItem.currentCount % 100) == 0
              ? 1.0
              : (currentItem.currentCount % 100) / 100);
    }
    return (cycleCount / target).clamp(0.0, 1.0);
  }

  List<WirdItem> get enabledWirdItems =>
      wirdItems.where((i) => i.isEnabled).toList();

  int get wirdCompletedCount =>
      enabledWirdItems.where((i) => i.isCompleted).length;

  int get wirdTotalEnabled => enabledWirdItems.length;

  double get wirdOverallProgress =>
      wirdTotalEnabled > 0 ? (wirdCompletedCount / wirdTotalEnabled) : 0.0;

  WirdItem? get activeWirdItem {
    if (wirdItems.isEmpty || activeWirdIndex < 0 || activeWirdIndex >= wirdItems.length) {
      return enabledWirdItems.isEmpty ? null : enabledWirdItems.first;
    }
    final candidate = wirdItems[activeWirdIndex];
    if (candidate.isEnabled) return candidate;
    return enabledWirdItems.isEmpty ? null : enabledWirdItems.first;
  }

  TasbeehState copyWith({
    TasbeehMode? mode,
    List<TasbeehItem>? items,
    int? selectedIndex,
    int? target,
    int? sessionTotal,
    int? lifetimeTotal,
    TasbeehFeedbackMode? feedbackMode,
    bool? isTargetReached,
    List<WirdItem>? wirdItems,
    int? activeWirdIndex,
    bool? isWirdCompleted,
  }) {
    return TasbeehState(
      mode: mode ?? this.mode,
      items: items ?? this.items,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      target: target ?? this.target,
      sessionTotal: sessionTotal ?? this.sessionTotal,
      lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
      feedbackMode: feedbackMode ?? this.feedbackMode,
      isTargetReached: isTargetReached ?? this.isTargetReached,
      wirdItems: wirdItems ?? this.wirdItems,
      activeWirdIndex: activeWirdIndex ?? this.activeWirdIndex,
      isWirdCompleted: isWirdCompleted ?? this.isWirdCompleted,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        items,
        selectedIndex,
        target,
        sessionTotal,
        lifetimeTotal,
        feedbackMode,
        isTargetReached,
        wirdItems,
        activeWirdIndex,
        isWirdCompleted,
      ];
}
