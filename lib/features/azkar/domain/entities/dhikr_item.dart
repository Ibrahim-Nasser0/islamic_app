import 'package:equatable/equatable.dart';

/// Single Dhikr entity with Arabic sacred text, repetition count, virtue, and reference
class DhikrItem extends Equatable {
  final String id;
  final String arabicText;
  final int targetCount;
  final int remainingCount;
  final String? fadl;
  final String? reference;

  const DhikrItem({
    required this.id,
    required this.arabicText,
    required this.targetCount,
    required this.remainingCount,
    this.fadl,
    this.reference,
  });

  bool get isCompleted => remainingCount <= 0;

  double get progress {
    if (targetCount <= 0) return 1.0;
    final done = targetCount - remainingCount;
    return (done / targetCount).clamp(0.0, 1.0);
  }

  DhikrItem copyWith({
    String? id,
    String? arabicText,
    int? targetCount,
    int? remainingCount,
    String? fadl,
    String? reference,
  }) {
    return DhikrItem(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      targetCount: targetCount ?? this.targetCount,
      remainingCount: remainingCount ?? this.remainingCount,
      fadl: fadl ?? this.fadl,
      reference: reference ?? this.reference,
    );
  }

  @override
  List<Object?> get props => [
        id,
        arabicText,
        targetCount,
        remainingCount,
        fadl,
        reference,
      ];
}
