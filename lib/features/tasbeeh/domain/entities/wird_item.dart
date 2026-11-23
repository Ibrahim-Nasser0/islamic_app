import 'package:equatable/equatable.dart';

/// Represents an individual item in a structured daily Wird
class WirdItem extends Equatable {
  final String id;
  final String arabicText;
  final int targetCount;
  final int currentCount;
  final bool isEnabled;

  const WirdItem({
    required this.id,
    required this.arabicText,
    required this.targetCount,
    this.currentCount = 0,
    this.isEnabled = true,
  });

  bool get isCompleted => currentCount >= targetCount;

  double get progress =>
      targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 1.0;

  WirdItem copyWith({
    String? id,
    String? arabicText,
    int? targetCount,
    int? currentCount,
    bool? isEnabled,
  }) {
    return WirdItem(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [
        id,
        arabicText,
        targetCount,
        currentCount,
        isEnabled,
      ];
}
