import 'package:equatable/equatable.dart';

import '../../domain/entities/juz_info.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/surah_info.dart';

enum QuranTab { surahs, ajzaa, bookmarks }

class QuranState extends Equatable {
  final List<SurahInfo> surahs;
  final List<SurahInfo> filteredSurahs;
  final String searchQuery;
  final List<JuzInfo> ajzaa;
  final QuranBookmark? lastRead;
  final List<QuranBookmark> bookmarks;
  final double fontSize;
  final QuranTab currentTab;
  final bool isLoading;

  const QuranState({
    this.surahs = const [],
    this.filteredSurahs = const [],
    this.searchQuery = '',
    this.ajzaa = const [],
    this.lastRead,
    this.bookmarks = const [],
    this.fontSize = 22.0,
    this.currentTab = QuranTab.surahs,
    this.isLoading = false,
  });

  QuranState copyWith({
    List<SurahInfo>? surahs,
    List<SurahInfo>? filteredSurahs,
    String? searchQuery,
    List<JuzInfo>? ajzaa,
    QuranBookmark? lastRead,
    List<QuranBookmark>? bookmarks,
    double? fontSize,
    QuranTab? currentTab,
    bool? isLoading,
  }) {
    return QuranState(
      surahs: surahs ?? this.surahs,
      filteredSurahs: filteredSurahs ?? this.filteredSurahs,
      searchQuery: searchQuery ?? this.searchQuery,
      ajzaa: ajzaa ?? this.ajzaa,
      lastRead: lastRead ?? this.lastRead,
      bookmarks: bookmarks ?? this.bookmarks,
      fontSize: fontSize ?? this.fontSize,
      currentTab: currentTab ?? this.currentTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        surahs,
        filteredSurahs,
        searchQuery,
        ajzaa,
        lastRead,
        bookmarks,
        fontSize,
        currentTab,
        isLoading,
      ];
}
