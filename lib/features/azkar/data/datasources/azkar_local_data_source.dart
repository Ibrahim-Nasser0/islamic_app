import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/daos/azkar_dao.dart';
import '../../domain/entities/azkar_category.dart';
import '../../domain/entities/dhikr_item.dart';
import 'azkar_evening_data.dart';
import 'azkar_morning_data.dart';
import 'azkar_prayer_sleep_data.dart';
import 'azkar_quranic_duas_data.dart';

abstract class AzkarLocalDataSource {
  Future<List<AzkarCategory>> getCategories();
  Future<AzkarCategory> getCategoryById(String id);
  Future<void> updateDhikrCount(String categoryId, String dhikrId, int remaining);
  Future<void> resetCategory(String categoryId);
}

class AzkarLocalDataSourceImpl implements AzkarLocalDataSource {
  final SharedPreferences? _prefs;
  final AzkarDao? _azkarDao;

  AzkarLocalDataSourceImpl({
    SharedPreferences? sharedPreferences,
    AzkarDao? azkarDao,
  })  : _prefs = sharedPreferences,
        _azkarDao = azkarDao;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<List<AzkarCategory>> getCategories() async {
    final rawCategories = _getRawCategories();
    final List<AzkarCategory> loaded = [];
    for (final cat in rawCategories) {
      final items = await _hydrateItems(cat.id, cat.items);
      loaded.add(cat.copyWith(items: items));
    }
    return loaded;
  }

  @override
  Future<AzkarCategory> getCategoryById(String id) async {
    final rawCategories = _getRawCategories();
    final cat = rawCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => rawCategories.first,
    );
    final items = await _hydrateItems(cat.id, cat.items);
    return cat.copyWith(items: items);
  }

  @override
  Future<void> updateDhikrCount(String categoryId, String dhikrId, int remaining) async {
    final dao = _azkarDao;
    if (dao != null) {
      await dao.upsertRemaining(
        categoryId: categoryId,
        dhikrId: dhikrId,
        remainingCount: remaining,
      );
      return;
    }
    final prefs = await _getPrefs();
    await prefs.setInt('dhikr_${categoryId}_$dhikrId', remaining);
  }

  @override
  Future<void> resetCategory(String categoryId) async {
    final dao = _azkarDao;
    if (dao != null) {
      await dao.clearCategory(categoryId);
      return;
    }
    final prefs = await _getPrefs();
    final cat = await getCategoryById(categoryId);
    for (final item in cat.items) {
      await prefs.remove('dhikr_${categoryId}_${item.id}');
    }
  }

  Future<List<DhikrItem>> _hydrateItems(String catId, List<DhikrItem> items) async {
    final dao = _azkarDao;
    if (dao != null) {
      final remainingMap = await dao.getRemainingMap(catId);
      return items.map((item) {
        final savedRemaining = remainingMap[item.id];
        return item.copyWith(
          remainingCount: savedRemaining ?? item.targetCount,
        );
      }).toList();
    }
    final prefs = await _getPrefs();
    return items.map((item) {
      final savedRemaining = prefs.getInt('dhikr_${catId}_${item.id}');
      return item.copyWith(
        remainingCount: savedRemaining ?? item.targetCount,
      );
    }).toList();
  }

  List<AzkarCategory> _getRawCategories() {
    return [
      const AzkarCategory(
        id: 'morning',
        titleKey: 'azkar_morning',
        subtitleKey: 'azkar_morning_desc',
        icon: Icons.wb_sunny_rounded,
        items: AzkarMorningData.items,
      ),
      const AzkarCategory(
        id: 'evening',
        titleKey: 'azkar_evening',
        subtitleKey: 'azkar_evening_desc',
        icon: FlutterIslamicIcons.solidCrescentMoon,
        items: AzkarEveningData.items,
      ),
      const AzkarCategory(
        id: 'after_prayer',
        titleKey: 'azkar_after_prayer',
        subtitleKey: 'azkar_after_prayer_desc',
        icon: FlutterIslamicIcons.solidPrayer,
        items: AzkarPrayerSleepData.afterPrayerItems,
      ),
      const AzkarCategory(
        id: 'sleep',
        titleKey: 'azkar_sleep',
        subtitleKey: 'azkar_sleep_desc',
        icon: FlutterIslamicIcons.crescentMoon,
        items: AzkarPrayerSleepData.sleepItems,
      ),
      const AzkarCategory(
        id: 'quranic_duas',
        titleKey: 'azkar_quranic_duas',
        subtitleKey: 'azkar_quranic_duas_desc',
        icon: FlutterIslamicIcons.quran2,
        items: AzkarQuranicDuasData.items,
      ),
    ];
  }
}
