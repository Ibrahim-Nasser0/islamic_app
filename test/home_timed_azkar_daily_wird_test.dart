import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:islamic_app/features/azkar/domain/entities/azkar_category.dart';
import 'package:islamic_app/features/azkar/domain/entities/dhikr_item.dart';
import 'package:islamic_app/features/azkar/presentation/cubit/timed_azkar_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/cubit/timed_azkar_state.dart';
import 'package:islamic_app/features/quran/data/datasources/daily_wird_calculator.dart';
import 'package:islamic_app/features/quran/presentation/cubit/daily_wird_cubit.dart';
import 'package:islamic_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAzkarDataSource implements AzkarLocalDataSource {
  final Map<String, List<DhikrItem>> _store = {
    'morning': [
      const DhikrItem(id: 'm1', arabicText: 'ذكر الصباح ١', targetCount: 2, remainingCount: 2),
      const DhikrItem(id: 'm2', arabicText: 'ذكر الصباح ٢', targetCount: 1, remainingCount: 1),
    ],
    'evening': [
      const DhikrItem(id: 'e1', arabicText: 'ذكر المساء ١', targetCount: 1, remainingCount: 1),
    ],
    'sleep': [
      const DhikrItem(id: 's1', arabicText: 'ذكر النوم ١', targetCount: 1, remainingCount: 1),
    ],
  };

  @override
  Future<List<AzkarCategory>> getCategories() async =>
      _store.keys.map((id) => _cat(id)).toList();

  @override
  Future<AzkarCategory> getCategoryById(String id) async => _cat(id);

  AzkarCategory _cat(String id) => AzkarCategory(
        id: id,
        titleKey: 'azkar_$id',
        subtitleKey: 'azkar_${id}_desc',
        icon: Icons.wb_sunny,
        items: List<DhikrItem>.from(_store[id] ?? const []),
      );

  @override
  Future<void> updateDhikrCount(String categoryId, String dhikrId, int remaining) async {
    final list = _store[categoryId];
    if (list == null) return;
    _store[categoryId] = list
        .map((d) => d.id == dhikrId ? d.copyWith(remainingCount: remaining) : d)
        .toList();
  }

  @override
  Future<void> resetCategory(String categoryId) async {
    final list = _store[categoryId];
    if (list == null) return;
    _store[categoryId] =
        list.map((d) => d.copyWith(remainingCount: d.targetCount)).toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyWirdCalculator', () {
    const calculator = DailyWirdCalculator();

    test('crosses surah boundary sequentially from 1:5 with count 5', () {
      final start = calculator.surahAyahToGlobal(1, 5);
      final slice = calculator.buildSlice(startGlobalAyah: start, count: 5);

      expect(slice.verses.length, 5);
      expect(
        slice.verses.map((v) => '${v.surahNumber}:${v.ayahNumber}').toList(),
        ['1:5', '1:6', '1:7', '2:1', '2:2'],
      );
      expect(slice.nextGlobalAyah, start + 5);
    });

    test('wraps cleanly from 114:6 back to 1:1', () {
      final total = calculator.totalQuranVerses;
      final slice = calculator.buildSlice(startGlobalAyah: total - 1, count: 4);

      expect(total, 6236);
      expect(
        slice.verses.map((v) => '${v.surahNumber}:${v.ayahNumber}').toList(),
        ['114:5', '114:6', '1:1', '1:2'],
      );
      expect(slice.nextGlobalAyah, 3);
    });
  });

  group('DailyWirdCubit', () {
    late SettingsLocalDataSourceImpl settingsDs;
    late DailyWirdCubit cubit;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      settingsDs = SettingsLocalDataSourceImpl(prefs);
      cubit = DailyWirdCubit(settingsDs: settingsDs);
    });

    tearDown(() => cubit.close());

    test('defaults to 5 ayahs, completes today, auto-advances next day', () async {
      final day1 = DateTime(2026, 11, 25);
      await cubit.loadWird(now: day1);

      expect(cubit.state.dailyCount, 5);
      expect(cubit.state.slice!.startGlobalAyah, 1);
      expect(cubit.state.slice!.endGlobalAyah, 5);
      expect(cubit.state.isCompletedForCurrentBatch, isFalse);

      await cubit.markCompleted(now: day1);
      expect(cubit.state.isCompletedForCurrentBatch, isTrue);

      await cubit.loadWird(now: day1);
      expect(cubit.state.slice!.startGlobalAyah, 1);
      expect(cubit.state.isCompletedForCurrentBatch, isTrue);

      final day2 = DateTime(2026, 11, 26);
      await cubit.loadWird(now: day2);
      expect(cubit.state.slice!.startGlobalAyah, 6);
      expect(cubit.state.slice!.endGlobalAyah, 10);
      expect(cubit.state.isCompletedForCurrentBatch, isFalse);
    });

    test('moveToNextBatch, setDailyCount, and resetToFatihah work properly', () async {
      await cubit.loadWird(now: DateTime(2026, 11, 25));
      await cubit.moveToNextBatch();
      expect(cubit.state.slice!.startGlobalAyah, 6);

      await cubit.setDailyCount(10);
      expect(cubit.state.dailyCount, 10);
      expect(cubit.state.slice!.verses.length, 10);
      expect(settingsDs.getDailyWirdCount(), 10);

      await cubit.resetToFatihah();
      expect(cubit.state.slice!.startGlobalAyah, 1);
    });
  });

  group('TimedAzkarCubit', () {
    test('resolves time period based on clock', () {
      expect(
        TimedAzkarCubit.resolveRecommendedPeriod(now: DateTime(2026, 11, 25, 8, 0)),
        AzkarTimePeriod.morning,
      );
      expect(
        TimedAzkarCubit.resolveRecommendedPeriod(now: DateTime(2026, 11, 25, 16, 30)),
        AzkarTimePeriod.evening,
      );
      expect(
        TimedAzkarCubit.resolveRecommendedPeriod(now: DateTime(2026, 11, 25, 23, 0)),
        AzkarTimePeriod.sleep,
      );
      expect(
        TimedAzkarCubit.resolveRecommendedPeriod(now: DateTime(2026, 11, 25, 2, 0)),
        AzkarTimePeriod.sleep,
      );
    });

    test('decrements active dhikr and resets current period', () async {
      final cubit = TimedAzkarCubit(_FakeAzkarDataSource());
      await cubit.loadForCurrentTime(now: DateTime(2026, 11, 25, 8, 0));

      expect(cubit.state.selectedPeriod, AzkarTimePeriod.morning);
      expect(cubit.state.activeDhikr!.id, 'm1');

      await cubit.decrementActiveDhikr();
      expect(cubit.state.activeDhikr!.remainingCount, 1);

      await cubit.decrementActiveDhikr();
      expect(cubit.state.activeDhikr!.id, 'm2');

      await cubit.decrementActiveDhikr();
      expect(cubit.state.activeDhikr, isNull);

      await cubit.resetCurrentPeriod();
      expect(cubit.state.activeDhikr!.id, 'm1');

      await cubit.ensureLoaded();
      expect(cubit.state.category, isNotNull);
      await cubit.close();
    });
  });
}
