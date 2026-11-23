import 'package:equatable/equatable.dart';

import '../../domain/entities/azkar_category.dart';

class AzkarState extends Equatable {
  final List<AzkarCategory> categories;
  final AzkarCategory? activeCategory;
  final bool isLoading;
  final String? errorMessage;
  final String? justCompletedDhikrId;
  final bool isCategoryCelebrated;

  const AzkarState({
    this.categories = const [],
    this.activeCategory,
    this.isLoading = false,
    this.errorMessage,
    this.justCompletedDhikrId,
    this.isCategoryCelebrated = false,
  });

  AzkarState copyWith({
    List<AzkarCategory>? categories,
    AzkarCategory? activeCategory,
    bool? isLoading,
    String? errorMessage,
    String? justCompletedDhikrId,
    bool? isCategoryCelebrated,
  }) {
    return AzkarState(
      categories: categories ?? this.categories,
      activeCategory: activeCategory ?? this.activeCategory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      justCompletedDhikrId: justCompletedDhikrId,
      isCategoryCelebrated: isCategoryCelebrated ?? this.isCategoryCelebrated,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        activeCategory,
        isLoading,
        errorMessage,
        justCompletedDhikrId,
        isCategoryCelebrated,
      ];
}
