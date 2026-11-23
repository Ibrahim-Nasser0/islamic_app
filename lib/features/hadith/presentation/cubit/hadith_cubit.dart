import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hadith_item.dart';
import '../../domain/repositories/hadith_repository.dart';
import 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  final HadithRepository repository;

  HadithCubit({required this.repository}) : super(const HadithState());

  Future<void> loadHadiths([String bookId = 'nawawi']) async {
    emit(state.copyWith(isLoading: true, activeBookId: bookId));
    final result = await repository.getHadithsByBook(bookId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (list) => emit(state.copyWith(
        isLoading: false,
        hadiths: list,
        filteredHadiths: list,
        searchQuery: '',
      )),
    );
  }

  void searchHadiths(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      emit(state.copyWith(searchQuery: '', filteredHadiths: state.hadiths));
      return;
    }

    final filtered = state.hadiths.where((h) {
      final matchesNumber = h.number.toString() == trimmed;
      final matchesTitle = h.title.toLowerCase().contains(trimmed);
      final matchesText = h.arabicText.contains(trimmed);
      final matchesNarrator = h.narrator.contains(trimmed);
      final matchesChapter = h.chapter?.contains(trimmed) ?? false;
      return matchesNumber || matchesTitle || matchesText || matchesNarrator || matchesChapter;
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredHadiths: filtered,
    ));
  }

  void selectHadith(HadithItem hadith) {
    emit(state.copyWith(selectedHadith: hadith));
  }
}
