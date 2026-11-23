import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/juz_info.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/surah_info.dart';

abstract class QuranLocalDataSource {
  List<SurahInfo> getSurahs();
  List<JuzInfo> getAjzaa();
  Future<QuranBookmark?> getLastRead();
  Future<void> saveLastRead(QuranBookmark bookmark);
  Future<List<QuranBookmark>> getBookmarks();
  Future<void> toggleBookmark(QuranBookmark bookmark);
  Future<double> getFontSize();
  Future<void> saveFontSize(double size);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const String _lastReadKey = 'quran_last_read';
  static const String _bookmarksKey = 'quran_bookmarks';
  static const String _fontSizeKey = 'quran_font_size';

  @override
  List<SurahInfo> getSurahs() {
    final List<SurahInfo> list = [];
    for (int i = 1; i <= quran.totalSurahCount; i++) {
      list.add(
        SurahInfo(
          number: i,
          nameArabic: quran.getSurahNameArabic(i),
          nameEnglish: quran.getSurahName(i),
          totalVerses: quran.getVerseCount(i),
          isMakki: quran.getPlaceOfRevelation(i) == 'Makkah',
          juzNumber: quran.getJuzNumber(i, 1),
          pageNumber: quran.getPageNumber(i, 1),
        ),
      );
    }
    return list;
  }

  @override
  List<JuzInfo> getAjzaa() {
    final List<JuzInfo> list = [];
    for (int j = 1; j <= quran.totalJuzCount; j++) {
      final surahVerses = quran.getSurahAndVersesFromJuz(j);
      final firstSurahNum = surahVerses.keys.first;
      final firstVerseNum = surahVerses[firstSurahNum]?.first ?? 1;

      list.add(
        JuzInfo(
          number: j,
          startSurahName: quran.getSurahNameArabic(firstSurahNum),
          startSurahNumber: firstSurahNum,
          startVerseNumber: firstVerseNum,
          pageNumber: quran.getPageNumber(firstSurahNum, firstVerseNum),
        ),
      );
    }
    return list;
  }

  @override
  Future<QuranBookmark?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_lastReadKey);
    if (jsonStr == null) {
      return QuranBookmark(
        surahNumber: 18,
        surahName: quran.getSurahNameArabic(18),
        ayahNumber: 1,
        timestamp: DateTime.now(),
      );
    }
    try {
      return QuranBookmark.fromJson(jsonStr);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastRead(QuranBookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReadKey, bookmark.toJson());
  }

  @override
  Future<List<QuranBookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_bookmarksKey) ?? [];
    return list
        .map((s) {
          try {
            return QuranBookmark.fromJson(s);
          } catch (_) {
            return null;
          }
        })
        .whereType<QuranBookmark>()
        .toList();
  }

  @override
  Future<void> toggleBookmark(QuranBookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getBookmarks();
    final exists = list.any(
      (b) =>
          b.surahNumber == bookmark.surahNumber &&
          b.ayahNumber == bookmark.ayahNumber,
    );

    if (exists) {
      list.removeWhere(
        (b) =>
            b.surahNumber == bookmark.surahNumber &&
            b.ayahNumber == bookmark.ayahNumber,
      );
    } else {
      list.insert(0, bookmark);
    }

    final stringList = list.map((b) => b.toJson()).toList();
    await prefs.setStringList(_bookmarksKey, stringList);
  }

  @override
  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeKey) ?? 22.0;
  }

  @override
  Future<void> saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }
}
