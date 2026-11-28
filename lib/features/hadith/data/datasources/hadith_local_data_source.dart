import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/daily_hadith_entry.dart';
import '../../domain/entities/hadith_item.dart';

abstract class HadithLocalDataSource {
  Future<List<HadithItem>> getHadithsByBook(String bookId);
  Future<HadithItem?> getHadithByNumber(String bookId, int number);
  Future<List<DailyHadithEntry>> getAllHadithsPool();
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  static const List<String> _bookIds = [
    'nawawi',
    'bukhari',
    'muslim',
    'riyad',
  ];

  final Map<String, List<HadithItem>> _cache = {};

  @override
  Future<List<HadithItem>> getHadithsByBook(String bookId) async {
    final normalizedId = _normalizeBookId(bookId);
    if (_cache.containsKey(normalizedId)) {
      return _cache[normalizedId]!;
    }

    try {
      final jsonStr =
          await rootBundle.loadString('assets/hadith/$normalizedId.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      final hadiths = list
          .map((item) => HadithItem.fromJson(item as Map<String, dynamic>))
          .toList();
      _cache[normalizedId] = hadiths;
      return hadiths;
    } catch (e, stackTrace) {
      debugPrint(
        '[HadithLocalDataSource] Failed loading $normalizedId.json: $e\n$stackTrace',
      );
      return [];
    }
  }

  @override
  Future<HadithItem?> getHadithByNumber(String bookId, int number) async {
    final list = await getHadithsByBook(bookId);
    for (final item in list) {
      if (item.number == number) return item;
    }
    return null;
  }

  @override
  Future<List<DailyHadithEntry>> getAllHadithsPool() async {
    final pool = <DailyHadithEntry>[];
    for (final bookId in _bookIds) {
      final list = await getHadithsByBook(bookId);
      for (final item in list) {
        if (item.arabicText.trim().isNotEmpty) {
          pool.add(DailyHadithEntry(bookId: bookId, hadith: item));
        }
      }
    }
    return pool;
  }

  String _normalizeBookId(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'bukhari':
      case 'sahih_bukhari':
        return 'bukhari';
      case 'muslim':
      case 'sahih_muslim':
        return 'muslim';
      case 'riyad':
      case 'riyad_assalihin':
        return 'riyad';
      case 'nawawi':
      case 'nawawi_forty':
      default:
        return 'nawawi';
    }
  }
}
