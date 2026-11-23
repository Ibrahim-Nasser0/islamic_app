import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Bookmark pointing to a specific Ayah in a Surah with timestamp
class QuranBookmark extends Equatable {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final DateTime timestamp;

  const QuranBookmark({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QuranBookmark.fromMap(Map<String, dynamic> map) {
    return QuranBookmark(
      surahNumber: map['surahNumber'] as int,
      surahName: map['surahName'] as String,
      ayahNumber: map['ayahNumber'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuranBookmark.fromJson(String source) =>
      QuranBookmark.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [surahNumber, surahName, ayahNumber, timestamp];
}
