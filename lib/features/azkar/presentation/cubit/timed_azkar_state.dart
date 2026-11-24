import 'package:equatable/equatable.dart';
import '../../domain/entities/azkar_category.dart';
import '../../domain/entities/dhikr_item.dart';

enum AzkarTimePeriod {
  morning('morning', 'azkar_morning'),
  evening('evening', 'azkar_evening'),
  sleep('sleep', 'azkar_sleep');

  final String categoryId;
  final String titleKey;
  const AzkarTimePeriod(this.categoryId, this.titleKey);
}

class TimedAzkarState extends Equatable {
  final AzkarTimePeriod recommendedPeriod;
  final AzkarTimePeriod selectedPeriod;
  final AzkarCategory? category;
  final bool isLoading;

  const TimedAzkarState({
    this.recommendedPeriod = AzkarTimePeriod.morning,
    this.selectedPeriod = AzkarTimePeriod.morning,
    this.category,
    this.isLoading = true,
  });

  bool get isRecommendedActive => recommendedPeriod == selectedPeriod;

  DhikrItem? get activeDhikr {
    final items = category?.items;
    if (items == null || items.isEmpty) return null;
    for (final item in items) {
      if (!item.isCompleted) return item;
    }
    return null;
  }

  TimedAzkarState copyWith({
    AzkarTimePeriod? recommendedPeriod,
    AzkarTimePeriod? selectedPeriod,
    AzkarCategory? category,
    bool? isLoading,
  }) {
    return TimedAzkarState(
      recommendedPeriod: recommendedPeriod ?? this.recommendedPeriod,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      category: category ?? this.category,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        recommendedPeriod,
        selectedPeriod,
        category,
        isLoading,
      ];
}
