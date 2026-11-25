import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:islamic_app/core/database/app_database.dart';
import 'package:islamic_app/core/database/shared_prefs_migrator.dart';
import 'package:islamic_app/core/utils/constants.dart';
import 'package:islamic_app/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:islamic_app/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:islamic_app/features/quran/domain/entities/quran_bookmark.dart';
import 'package:islamic_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:islamic_app/features/tasbeeh/data/datasources/tasbeeh_local_data_source.dart';
import 'package:islamic_app/features/tasbeeh/domain/entities/tasbeeh_defaults.dart';
import 'package:islamic_app/features/tasbeeh/domain/entities/tasbeeh_feedback_mode.dart';
import 'package:islamic_app/features/tasbeeh/domain/entities/wird_item.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('SharedPrefsToDriftMigrator migrates all legacy keys idempotently',
      () async {
    final bookmark = QuranBookmark(
      surahNumber: 2,
      surahName: 'البقرة',
      ayahNumber: 255,
      timestamp: DateTime(2026, 5, 1, 10, 30),
    );
    final lastRead = QuranBookmark(
      surahNumber: 36,
      surahName: 'يس',
      ayahNumber: 12,
      timestamp: DateTime(2026, 5, 2, 8, 0),
    );

    SharedPreferences.setMockInitialValues({
      'tasbeeh_free_counts': jsonEncode({
        'subhan_allah': {'current': 17, 'total': 170},
      }),
      'tasbeeh_wird_items': jsonEncode([
        {
          'id': TasbeehDefaults.defaultWird.first.id,
          'arabicText': TasbeehDefaults.defaultWird.first.arabicText,
          'targetCount': 100,
          'currentCount': 42,
          'isEnabled': true,
        },
        {
          'id': 'custom_1',
          'arabicText': 'يا حي يا قيوم برحمتك أستغيث',
          'targetCount': 10,
          'currentCount': 3,
          'isEnabled': true,
        },
      ]),
      'quran_bookmarks': [bookmark.toJson()],
      'quran_last_read': lastRead.toJson(),
      AppConstants.dailyWirdCountKey: 12,
      AppConstants.dailyWirdCursorKey: 250,
      AppConstants.dailyWirdCompletedDateKey: '2026-05-02',
      AppConstants.dailyWirdCursorCompletedKey: true,
      AppConstants.dailyWirdLastBatchEndKey: 249,
      'dhikr_morning_m_1': 0,
      'dhikr_after_prayer_ap_1': 2,
      'dhikr_quranic_duas_qd_2': 1,
    });
    final prefs = await SharedPreferences.getInstance();

    await SharedPrefsToDriftMigrator.migrateIfNeeded(db, prefs);
    expect(prefs.getBool(SharedPrefsToDriftMigrator.migratedFlagKey), isTrue);

    final tasbeehs = await db.tasbeehDao.getAllTasbeehEntries();
    final subhan = tasbeehs.firstWhere((e) => e.id == 'subhan_allah');
    expect(subhan.currentCount, 17);
    expect(subhan.totalCount, 170);

    final wirds = await db.tasbeehDao.getAllWirdEntries();
    expect(wirds.length, 2);
    expect(wirds[0].isCustom, isFalse);
    expect(wirds[1].isCustom, isTrue);
    expect(wirds[1].currentCount, 3);

    final bookmarks = await db.quranDao.getBookmarks();
    expect(bookmarks.single.surahNumber, 2);
    expect(bookmarks.single.ayahNumber, 255);

    final readingState = await db.quranDao.getOrCreateReadingState();
    expect(readingState.lastSurah, 36);
    expect(readingState.lastAyah, 12);
    expect(readingState.wirdDailyCount, 12);
    expect(readingState.wirdCursorAyah, 250);
    expect(readingState.wirdCompletedDate, '2026-05-02');
    expect(readingState.wirdCursorCompleted, isTrue);

    expect((await db.azkarDao.getRemainingMap('morning'))['m_1'], 0);
    expect((await db.azkarDao.getRemainingMap('after_prayer'))['ap_1'], 2);
    expect((await db.azkarDao.getRemainingMap('quranic_duas'))['qd_2'], 1);

    // Mutate DB and ensure second run does not overwrite
    await db.azkarDao.upsertRemaining(
      categoryId: 'morning',
      dhikrId: 'm_1',
      remainingCount: 99,
    );
    await SharedPrefsToDriftMigrator.migrateIfNeeded(db, prefs);
    expect((await db.azkarDao.getRemainingMap('morning'))['m_1'], 99);
  });

  test('QuranLocalDataSourceImpl & AzkarLocalDataSourceImpl read/write Drift',
      () async {
    SharedPreferences.setMockInitialValues({});
    final quranDs = QuranLocalDataSourceImpl(quranDao: db.quranDao);
    final b = QuranBookmark(
      surahNumber: 1,
      surahName: 'الفاتحة',
      ayahNumber: 7,
      timestamp: DateTime(2026, 6, 1),
    );
    await quranDs.saveLastRead(b);
    expect((await quranDs.getLastRead())?.surahNumber, 1);

    await quranDs.toggleBookmark(b);
    expect((await quranDs.getBookmarks()).length, 1);
    await quranDs.toggleBookmark(b);
    expect(await quranDs.getBookmarks(), isEmpty);

    final azkarDs = AzkarLocalDataSourceImpl(azkarDao: db.azkarDao);
    await azkarDs.updateDhikrCount('morning', 'm_1', 0);
    final morning = await azkarDs.getCategoryById('morning');
    expect(morning.items.first.remainingCount, 0);

    await azkarDs.resetCategory('morning');
    final resetMorning = await azkarDs.getCategoryById('morning');
    expect(resetMorning.items.first.remainingCount,
        resetMorning.items.first.targetCount);
  });

  test('TasbeehLocalDataSourceImpl & Settings daily logs persist in Drift',
      () async {
    SharedPreferences.setMockInitialValues({'tasbeeh_lifetime_total': 10});
    final prefs = await SharedPreferences.getInstance();
    final tasbeehDs = TasbeehLocalDataSourceImpl(prefs, tasbeehDao: db.tasbeehDao);
    final now = DateTime(2026, 6, 15, 12);

    await tasbeehDs.warmUp(now: now);
    final initial = tasbeehDs.loadSnapshot(now: now);

    final updatedItems = [
      initial.items.first.copyWith(currentCount: 5, totalCount: 15),
      ...initial.items.skip(1),
    ];
    final updatedWirds = [
      const WirdItem(
        id: 'w1',
        arabicText: 'سبحان الله',
        targetCount: 10,
        currentCount: 10,
      ),
    ];

    await tasbeehDs.saveSnapshot(
      TasbeehSnapshot(
        selectedIndex: 0,
        target: 33,
        lifetimeTotal: 15,
        feedbackMode: TasbeehFeedbackMode.haptic,
        items: updatedItems,
        wirdItems: updatedWirds,
        activeWirdIndex: 0,
      ),
      now: now,
    );

    final settingsDs = SettingsLocalDataSourceImpl(
      prefs,
      quranDao: db.quranDao,
      tasbeehDao: db.tasbeehDao,
    );
    await settingsDs.setDailyWirdCount(8);
    await settingsDs.setDailyWirdCompletedDate('2026-06-15');

    final log = await db.tasbeehDao.getLogForDate('2026-06-15');
    expect(log, isNotNull);
    expect(log!.tasbeehCount, 5);
    expect(log.wirdCompletedCount, 1);
    expect(log.allWirdCompleted, isTrue);
    expect(log.quranAyahsRead, 8);
  });
}
