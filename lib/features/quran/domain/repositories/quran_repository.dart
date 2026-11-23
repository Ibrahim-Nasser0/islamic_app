import '../../domain/entities/juz_info.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/surah_info.dart';

abstract class QuranRepository {
  List<SurahInfo> getSurahs();
  List<JuzInfo> getAjzaa();
  Future<QuranBookmark?> getLastRead();
  Future<void> saveLastRead(QuranBookmark bookmark);
  Future<List<QuranBookmark>> getBookmarks();
  Future<void> toggleBookmark(QuranBookmark bookmark);
  Future<double> getFontSize();
  Future<void> saveFontSize(double size);
}
