import 'package:equatable/equatable.dart';

/// Immutable domain representation of a Prophetic Hadith with documented scholarly grade.
class HadithItem extends Equatable {
  static const String tierMuttafaq = 'muttafaq';
  static const String tierSahih = 'sahih';
  static const String tierHasanSahih = 'hasan_sahih';
  static const String tierHasan = 'hasan';
  static const String tierCitationInText = 'needs_verification';

  final int number;
  final String title;
  final String arabicText;
  final String narrator;
  final String reference;
  final String? benefit;
  final String? chapter;
  final String gradeTier;
  final String gradeLabelAr;
  final String gradeLabelEn;
  final int strengthScore;

  const HadithItem({
    required this.number,
    required this.title,
    required this.arabicText,
    required this.narrator,
    required this.reference,
    this.benefit,
    this.chapter,
    this.gradeTier = tierSahih,
    this.gradeLabelAr = 'صحيح',
    this.gradeLabelEn = 'Authentic (Sahih)',
    this.strengthScore = 4,
  });

  String localizedGradeLabel(String languageCode) =>
      languageCode == 'ar' ? gradeLabelAr : gradeLabelEn;

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    return HadithItem(
      number: (json['number'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      arabicText: json['arabicText'] as String? ?? '',
      narrator: json['narrator'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      benefit: json['benefit'] as String?,
      chapter: json['chapter'] as String?,
      gradeTier: json['gradeTier'] as String? ?? tierSahih,
      gradeLabelAr: json['gradeLabelAr'] as String? ?? 'صحيح',
      gradeLabelEn: json['gradeLabelEn'] as String? ?? 'Authentic (Sahih)',
      strengthScore: (json['strengthScore'] as num?)?.toInt() ?? 4,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'title': title,
        'arabicText': arabicText,
        'narrator': narrator,
        'reference': reference,
        if (benefit != null) 'benefit': benefit,
        if (chapter != null) 'chapter': chapter,
        'gradeTier': gradeTier,
        'gradeLabelAr': gradeLabelAr,
        'gradeLabelEn': gradeLabelEn,
        'strengthScore': strengthScore,
      };

  @override
  List<Object?> get props => [
        number,
        title,
        arabicText,
        narrator,
        reference,
        benefit,
        chapter,
        gradeTier,
        gradeLabelAr,
        gradeLabelEn,
        strengthScore,
      ];
}
