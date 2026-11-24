import 'package:quran/quran.dart' as quran;
import '../../domain/entities/daily_wird_verse.dart';

/// Pure sequential Mushaf slicing calculator across all 114 Surahs (Al-Fatihah 1:1 -> An-Nas 114:6).
class DailyWirdCalculator {
  const DailyWirdCalculator();

  int get totalQuranVerses {
    int sum = 0;
    for (int s = 1; s <= quran.totalSurahCount; s++) {
      sum += quran.getVerseCount(s);
    }
    return sum;
  }

  ({int surah, int ayah}) globalToSurahAyah(int globalIndex) {
    final total = totalQuranVerses;
    final normalized = ((globalIndex - 1) % total) + 1;
    int remaining = normalized;
    for (int s = 1; s <= quran.totalSurahCount; s++) {
      final verseCount = quran.getVerseCount(s);
      if (remaining <= verseCount) {
        return (surah: s, ayah: remaining);
      }
      remaining -= verseCount;
    }
    return const (surah: 1, ayah: 1);
  }

  int surahAyahToGlobal(int surah, int ayah) {
    final clampedSurah = surah.clamp(1, quran.totalSurahCount);
    int offset = 0;
    for (int s = 1; s < clampedSurah; s++) {
      offset += quran.getVerseCount(s);
    }
    final maxVerse = quran.getVerseCount(clampedSurah);
    return offset + ayah.clamp(1, maxVerse);
  }

  DailyWirdSlice buildSlice({
    required int startGlobalAyah,
    required int count,
  }) {
    final total = totalQuranVerses;
    final safeCount = count.clamp(1, 50);
    final safeStart = ((startGlobalAyah - 1) % total) + 1;

    final List<DailyWirdVerse> verses = [];
    int currentGlobal = safeStart;

    for (int i = 0; i < safeCount; i++) {
      final coords = globalToSurahAyah(currentGlobal);
      verses.add(
        DailyWirdVerse(
          globalIndex: currentGlobal,
          surahNumber: coords.surah,
          surahNameAr: quran.getSurahNameArabic(coords.surah),
          surahNameEn: quran.getSurahName(coords.surah),
          ayahNumber: coords.ayah,
          arabicText: quran.getVerse(
            coords.surah,
            coords.ayah,
            verseEndSymbol: true,
          ),
          pageNumber: quran.getPageNumber(coords.surah, coords.ayah),
          juzNumber: quran.getJuzNumber(coords.surah, coords.ayah),
        ),
      );
      currentGlobal = currentGlobal >= total ? 1 : currentGlobal + 1;
    }

    final endGlobal = verses.last.globalIndex;
    return DailyWirdSlice(
      verses: verses,
      startGlobalAyah: safeStart,
      endGlobalAyah: endGlobal,
      nextGlobalAyah: currentGlobal,
      totalQuranVerses: total,
    );
  }
}
