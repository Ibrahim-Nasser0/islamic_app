import 'dart:convert';
import 'package:flutter/services.dart';

import '../../domain/entities/hadith_item.dart';

abstract class HadithLocalDataSource {
  Future<List<HadithItem>> getHadithsByBook(String bookId);
  Future<HadithItem?> getHadithByNumber(String bookId, int number);
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
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
    } catch (_) {
      return [];
    }
  }

  @override
  Future<HadithItem?> getHadithByNumber(String bookId, int number) async {
    final list = await getHadithsByBook(bookId);
    try {
      return list.firstWhere((h) => h.number == number);
    } catch (_) {
      return null;
    }
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
