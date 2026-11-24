import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/native/permission_readiness_cubit.dart';
import 'package:islamic_app/core/services/native/permission_readiness_state.dart';
import 'package:islamic_app/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:islamic_app/features/azkar/domain/entities/azkar_category.dart';
import 'package:islamic_app/features/azkar/domain/entities/dhikr_item.dart';
import 'package:islamic_app/features/home/domain/entities/daily_prayer_schedule.dart';
import 'package:islamic_app/features/home/domain/entities/prayer_time_entry.dart';
import 'package:islamic_app/features/home/domain/repositories/prayer_repository.dart';

class FileJsonAssetLoader extends AssetLoader {
  const FileJsonAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final file = File('$path/${locale.languageCode}.json');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

class FakePrayerRepository implements PrayerRepository {
  @override
  Future<DailyPrayerSchedule> getDailyPrayerSchedule({
    double? latitude,
    double? longitude,
    String? nameAr,
    String? nameEn,
    DateTime? date,
  }) async {
    final base = DateTime(2026, 11, 25, 4, 45);
    final prayers = [
      PrayerTimeEntry(
        type: PrayerType.fajr,
        nameAr: 'الفجر',
        nameEn: 'Fajr',
        time: base,
        icon: Icons.nightlight_round,
        status: PrayerEntryStatus.past,
      ),
      PrayerTimeEntry(
        type: PrayerType.sunrise,
        nameAr: 'الشروق',
        nameEn: 'Sunrise',
        time: base.add(const Duration(hours: 1, minutes: 25)),
        icon: Icons.wb_twilight_rounded,
        status: PrayerEntryStatus.past,
      ),
      PrayerTimeEntry(
        type: PrayerType.dhuhr,
        nameAr: 'الظهر',
        nameEn: 'Dhuhr',
        time: base.add(const Duration(hours: 7)),
        icon: Icons.wb_sunny_rounded,
        status: PrayerEntryStatus.next,
      ),
      PrayerTimeEntry(
        type: PrayerType.asr,
        nameAr: 'العصر',
        nameEn: 'Asr',
        time: base.add(const Duration(hours: 10)),
        icon: Icons.sunny_snowing,
      ),
      PrayerTimeEntry(
        type: PrayerType.maghrib,
        nameAr: 'المغرب',
        nameEn: 'Maghrib',
        time: base.add(const Duration(hours: 12, minutes: 20)),
        icon: Icons.nights_stay_outlined,
      ),
      PrayerTimeEntry(
        type: PrayerType.isha,
        nameAr: 'العشاء',
        nameEn: 'Isha',
        time: base.add(const Duration(hours: 13, minutes: 45)),
        icon: Icons.dark_mode_rounded,
      ),
    ];

    return DailyPrayerSchedule(
      prayers: prayers,
      currentPrayer: prayers[1],
      nextPrayer: prayers[2],
      timeToNextPrayer: const Duration(hours: 1, minutes: 45, seconds: 12),
      locationNameAr: 'القاهرة، مصر (موقع طويل للاختبار)',
      locationNameEn: 'Cairo, Egypt (Long Location Name)',
      hijriDateAr: '15 جمادى الأولى 1448 هـ',
      hijriDateEn: '15 Jumada Al-Ula 1448 AH',
      date: DateTime(2026, 11, 25),
      latitude: 30.0444,
      longitude: 31.2357,
    );
  }

  @override
  Future<({double latitude, double longitude, String nameAr, String nameEn})>
      detectCurrentLocation() async => (
            latitude: 30.0444,
            longitude: 31.2357,
            nameAr: 'القاهرة، مصر (موقع طويل للاختبار)',
            nameEn: 'Cairo, Egypt (Long Location Name)',
          );
}

class FakeAzkarLocalDataSource implements AzkarLocalDataSource {
  @override
  Future<List<AzkarCategory>> getCategories() async => [
        await getCategoryById('morning'),
        await getCategoryById('evening'),
        await getCategoryById('sleep'),
      ];

  @override
  Future<AzkarCategory> getCategoryById(String id) async => AzkarCategory(
        id: id,
        titleKey: 'azkar_$id',
        subtitleKey: 'azkar_${id}_desc',
        icon: Icons.wb_sunny,
        items: const [
          DhikrItem(
            id: 'd1',
            arabicText: 'أصبحنا وأصبح الملك لله والحمد لله لا إله إلا الله وحده لا شريك له',
            targetCount: 3,
            remainingCount: 3,
          ),
        ],
      );

  @override
  Future<void> resetCategory(String categoryId) async {}

  @override
  Future<void> updateDhikrCount(
    String categoryId,
    String dhikrId,
    int remaining,
  ) async {}
}

class StubPermissionReadinessCubit extends Cubit<PermissionReadinessState>
    implements PermissionReadinessCubit {
  StubPermissionReadinessCubit()
      : super(const PermissionReadinessState(notificationsGranted: false));

  @override
  Future<void> refresh() async {}

  @override
  Future<void> requestEssentialBatch() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
