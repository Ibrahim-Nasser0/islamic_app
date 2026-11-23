import 'package:equatable/equatable.dart';

import '../../domain/entities/hadith_item.dart';

class HadithState extends Equatable {
  final List<HadithItem> hadiths;
  final List<HadithItem> filteredHadiths;
  final HadithItem? selectedHadith;
  final String activeBookId;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const HadithState({
    this.hadiths = const [],
    this.filteredHadiths = const [],
    this.selectedHadith,
    this.activeBookId = 'nawawi',
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  HadithState copyWith({
    List<HadithItem>? hadiths,
    List<HadithItem>? filteredHadiths,
    HadithItem? selectedHadith,
    String? activeBookId,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HadithState(
      hadiths: hadiths ?? this.hadiths,
      filteredHadiths: filteredHadiths ?? this.filteredHadiths,
      selectedHadith: selectedHadith ?? this.selectedHadith,
      activeBookId: activeBookId ?? this.activeBookId,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        hadiths,
        filteredHadiths,
        selectedHadith,
        activeBookId,
        searchQuery,
        isLoading,
        errorMessage,
      ];
}
