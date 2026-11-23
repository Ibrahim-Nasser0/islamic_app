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

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    return HadithItem(
      number: json['number'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      arabicText: json['arabicText'] as String? ?? '',
      narrator: json['narrator'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      benefit: json['benefit'] as String?,
      chapter: json['chapter'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'arabicText': arabicText,
      'narrator': narrator,
      'reference': reference,
      'benefit': benefit,
      'chapter': chapter,
    };
  }

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
