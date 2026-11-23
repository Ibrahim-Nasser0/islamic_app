import 'package:equatable/equatable.dart';

/// Prophetic Hadith Entity
class HadithItem extends Equatable {
  final int number;
  final String title;
  final String arabicText;
  final String narrator;
  final String reference;
  final String? benefit;
  final String? chapter;

  const HadithItem({
    required this.number,
    required this.title,
    required this.arabicText,
    required this.narrator,
    required this.reference,
    this.benefit,
    this.chapter,
  });

  @override
  List<Object?> get props => [
        number,
        title,
        arabicText,
        narrator,
        reference,
        benefit,
        chapter,
      ];
}
