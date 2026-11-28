import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hadith_item.dart';
import '../../domain/repositories/hadith_repository.dart';
import 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  static final RegExp _arabicDiacritics = RegExp(r'[\u064B-\u065F\u0670\u0640]');
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
    final trimmed = _normalizeArabic(query);
    if (trimmed.isEmpty) {
      emit(state.copyWith(searchQuery: '', filteredHadiths: state.hadiths));
      return;
    }

    final filtered = state.hadiths.where((h) {
      final matchesNumber = h.number.toString() == trimmed;
      final matchesTitle = _normalizeArabic(h.title).contains(trimmed);
      final matchesText = _normalizeArabic(h.arabicText).contains(trimmed);
      final matchesNarrator = _normalizeArabic(h.narrator).contains(trimmed);
      final matchesChapter =
          h.chapter != null && _normalizeArabic(h.chapter!).contains(trimmed);
      return matchesNumber ||
          matchesTitle ||
          matchesText ||
          matchesNarrator ||
          matchesChapter;
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredHadiths: filtered,
    ));
  }

  String _normalizeArabic(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll(_arabicDiacritics, '')
        .replaceAll(RegExp(r'[أإآٱ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  void selectHadith(HadithItem hadith) {
    emit(state.copyWith(selectedHadith: hadith));
  }
}
