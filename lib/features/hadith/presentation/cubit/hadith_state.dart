import 'package:equatable/equatable.dart';

import '../../domain/entities/hadith_item.dart';

class HadithState extends Equatable {
  static const Object _unset = Object();

  final List<HadithItem> hadiths;
  final HadithItem? selectedHadith;
  final String activeBookId;
  final String searchQuery;
  final String? gradeFilter;
  final int totalCount;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const HadithState({
    this.hadiths = const [],
    this.selectedHadith,
    this.activeBookId = '',
    this.searchQuery = '',
    this.gradeFilter,
    this.totalCount = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  HadithState copyWith({
    List<HadithItem>? hadiths,
    HadithItem? selectedHadith,
    String? activeBookId,
    String? searchQuery,
    Object? gradeFilter = _unset,
    int? totalCount,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return HadithState(
      hadiths: hadiths ?? this.hadiths,
      selectedHadith: selectedHadith ?? this.selectedHadith,
      activeBookId: activeBookId ?? this.activeBookId,
      searchQuery: searchQuery ?? this.searchQuery,
      gradeFilter:
          identical(gradeFilter, _unset) ? this.gradeFilter : gradeFilter as String?,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        hadiths,
        selectedHadith,
        activeBookId,
        searchQuery,
        gradeFilter,
        totalCount,
        hasMore,
        isLoading,
        isLoadingMore,
        errorMessage,
      ];
}
