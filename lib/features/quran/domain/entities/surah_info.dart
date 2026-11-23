import 'package:equatable/equatable.dart';

/// Metadata entity for a single Surah of the Holy Quran
class SurahInfo extends Equatable {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final int totalVerses;
  final bool isMakki;
  final int juzNumber;
  final int pageNumber;

  const SurahInfo({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.totalVerses,
    required this.isMakki,
    required this.juzNumber,
    required this.pageNumber,
  });

  @override
  List<Object?> get props => [
        number,
        nameArabic,
        nameEnglish,
        totalVerses,
        isMakki,
        juzNumber,
        pageNumber,
      ];
}
