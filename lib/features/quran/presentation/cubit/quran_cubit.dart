import 'package:bloc/bloc.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/utils/haptics.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/repositories/quran_repository.dart';
import 'quran_state.dart';

/// Cubit managing Quran index navigation, search, bookmarks, and reader preferences
class QuranCubit extends Cubit<QuranState> {
  final QuranRepository repository;

  QuranCubit({required this.repository}) : super(const QuranState()) {
    loadQuranData();
  }

  Future<void> loadQuranData() async {
    emit(state.copyWith(isLoading: true));
    final surahs = repository.getSurahs();
    final ajzaa = repository.getAjzaa();
    final lastRead = await repository.getLastRead();
    final bookmarks = await repository.getBookmarks();
    final fontSize = await repository.getFontSize();

    emit(state.copyWith(
      surahs: surahs,
      filteredSurahs: surahs,
      ajzaa: ajzaa,
      lastRead: lastRead,
      bookmarks: bookmarks,
      fontSize: fontSize,
      isLoading: false,
    ));
  }

  void search(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      emit(state.copyWith(
        searchQuery: '',
        filteredSurahs: state.surahs,
      ));
      return;
    }

    final filtered = state.surahs.where((s) {
      final matchNum = s.number.toString() == cleanQuery;
      final matchAr = s.nameArabic.contains(cleanQuery);
      final matchEn = s.nameEnglish.toLowerCase().contains(cleanQuery);
      return matchNum || matchAr || matchEn;
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredSurahs: filtered,
    ));
  }

  void setTab(QuranTab tab) {
    AppHaptics.selection();
    emit(state.copyWith(currentTab: tab));
  }

  Future<void> saveLastRead({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final bookmark = QuranBookmark(
      surahNumber: surahNumber,
      surahName: quran.getSurahNameArabic(surahNumber),
      ayahNumber: ayahNumber,
      timestamp: DateTime.now(),
    );
    await repository.saveLastRead(bookmark);
    emit(state.copyWith(lastRead: bookmark));
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    AppHaptics.light();
    final bookmark = QuranBookmark(
      surahNumber: surahNumber,
      surahName: quran.getSurahNameArabic(surahNumber),
      ayahNumber: ayahNumber,
      timestamp: DateTime.now(),
    );
    await repository.toggleBookmark(bookmark);
    final updated = await repository.getBookmarks();
    emit(state.copyWith(bookmarks: updated));
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    return state.bookmarks.any(
      (b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber,
    );
  }

  Future<void> setFontSize(double size) async {
    final clamped = size.clamp(16.0, 38.0);
    AppHaptics.selection();
    await repository.saveFontSize(clamped);
    emit(state.copyWith(fontSize: clamped));
  }

  void increaseFontSize() {
    setFontSize(state.fontSize + 2.0);
  }

  void decreaseFontSize() {
    setFontSize(state.fontSize - 2.0);
  }
}
