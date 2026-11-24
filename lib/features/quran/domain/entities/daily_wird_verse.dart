import 'package:equatable/equatable.dart';

/// Single verse entry inside a sequential Daily Quran Wird slice.
class DailyWirdVerse extends Equatable {
  final int globalIndex;
  final int surahNumber;
  final String surahNameAr;
  final String surahNameEn;
  final int ayahNumber;
  final String arabicText;
  final int pageNumber;
  final int juzNumber;

  const DailyWirdVerse({
    required this.globalIndex,
    required this.surahNumber,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.ayahNumber,
    required this.arabicText,
    required this.pageNumber,
    required this.juzNumber,
  });

  @override
  List<Object?> get props => [globalIndex, surahNumber, ayahNumber, arabicText];
}

/// Ordered slice of Quranic verses for today's consecutive Mushaf reading mission.
class DailyWirdSlice extends Equatable {
  final List<DailyWirdVerse> verses;
  final int startGlobalAyah;
  final int endGlobalAyah;
  final int nextGlobalAyah;
  final int totalQuranVerses;

  const DailyWirdSlice({
    required this.verses,
    required this.startGlobalAyah,
    required this.endGlobalAyah,
    required this.nextGlobalAyah,
    required this.totalQuranVerses,
  });

  double get khatmahProgress => totalQuranVerses > 0
      ? (endGlobalAyah / totalQuranVerses).clamp(0.0, 1.0)
      : 0.0;

  @override
  List<Object?> get props => [
        verses,
        startGlobalAyah,
        endGlobalAyah,
        nextGlobalAyah,
        totalQuranVerses,
      ];
}
