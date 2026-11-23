import 'package:equatable/equatable.dart';

/// Metadata entity representing one of the 30 Ajzaa of the Holy Quran
class JuzInfo extends Equatable {
  final int number;
  final String startSurahName;
  final int startSurahNumber;
  final int startVerseNumber;
  final int pageNumber;

  const JuzInfo({
    required this.number,
    required this.startSurahName,
    required this.startSurahNumber,
    required this.startVerseNumber,
    required this.pageNumber,
  });

  @override
  List<Object?> get props => [
        number,
        startSurahName,
        startSurahNumber,
        startVerseNumber,
        pageNumber,
      ];
}
