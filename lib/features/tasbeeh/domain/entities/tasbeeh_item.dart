import 'package:equatable/equatable.dart';

/// Represents a distinct sacred Dhikr phrase for the digital Tasbeeh
class TasbeehItem extends Equatable {
  final String id;
  final String arabicText;
  final String? virtueKey;
  final int defaultTarget;
  final int currentCount;
  final int totalCount;

  const TasbeehItem({
    required this.id,
    required this.arabicText,
    this.virtueKey,
    this.defaultTarget = 33,
    this.currentCount = 0,
    this.totalCount = 0,
  });

  TasbeehItem copyWith({
    String? id,
    String? arabicText,
    String? virtueKey,
    int? defaultTarget,
    int? currentCount,
    int? totalCount,
  }) {
    return TasbeehItem(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      virtueKey: virtueKey ?? this.virtueKey,
      defaultTarget: defaultTarget ?? this.defaultTarget,
      currentCount: currentCount ?? this.currentCount,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        arabicText,
        virtueKey,
        defaultTarget,
        currentCount,
        totalCount,
      ];
}
