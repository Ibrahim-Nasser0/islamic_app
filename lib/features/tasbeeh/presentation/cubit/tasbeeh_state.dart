import 'package:equatable/equatable.dart';
import '../../domain/entities/tasbeeh_item.dart';
import '../../domain/entities/wird_item.dart';

enum TasbeehMode { free, wird }

class TasbeehState extends Equatable {
  final TasbeehMode mode;
  final List<TasbeehItem> items;
  final int selectedIndex;
  final int target; // 33, 100, or 0 for unlimited
  final int sessionTotal;
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
    this.isTargetReached = false,
    this.wirdItems = const [],
    this.activeWirdIndex = 0,
    this.isWirdCompleted = false,
  });

  TasbeehItem get currentItem => items[selectedIndex];

  double get progress {
    if (target <= 0) return 1.0;
    return (currentItem.currentCount % target) / target;
  }

  List<WirdItem> get enabledWirdItems =>
      wirdItems.where((i) => i.isEnabled).toList();

  int get wirdCompletedCount =>
      enabledWirdItems.where((i) => i.isCompleted).length;

  int get wirdTotalEnabled => enabledWirdItems.length;

  double get wirdOverallProgress =>
      wirdTotalEnabled > 0 ? (wirdCompletedCount / wirdTotalEnabled) : 0.0;

  WirdItem? get activeWirdItem {
    if (wirdItems.isEmpty || activeWirdIndex >= wirdItems.length) return null;
    return wirdItems[activeWirdIndex];
  }

  TasbeehState copyWith({
    TasbeehMode? mode,
    List<TasbeehItem>? items,
    int? selectedIndex,
    int? target,
    int? sessionTotal,
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
        isTargetReached,
        wirdItems,
        activeWirdIndex,
        isWirdCompleted,
      ];
}
