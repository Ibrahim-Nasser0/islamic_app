import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/database/daos/hadith_search_helper.dart';
import 'package:islamic_app/core/database/hadith_catalog_database.dart';
import 'package:islamic_app/core/errors/failure.dart';
import 'package:islamic_app/core/theme/app_theme.dart';
import 'package:islamic_app/features/hadith/domain/entities/daily_hadith_entry.dart';
import 'package:islamic_app/features/hadith/domain/entities/hadith_item.dart';
import 'package:islamic_app/features/hadith/domain/repositories/hadith_repository.dart';
import 'package:islamic_app/features/hadith/presentation/cubit/daily_hadith_cubit.dart';
import 'package:islamic_app/features/hadith/views/widgets/hadith_strength_meter_card.dart';
import 'package:islamic_app/features/home/views/widgets/daily_hadith_highlight_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/home_layout_fakes.dart';

class _FakeHadithRepository implements HadithRepository {
  final List<DailyHadithEntry> pool;
  final Random _rnd = Random(13);

  _FakeHadithRepository(this.pool);

  @override
  Future<Either<Failure, List<HadithItem>>> getHadithsPage(
    String bookId, {
    required int limit,
    required int offset,
    String? gradeTier,
    String? searchQuery,
  }) async {
    final canonical = HadithSearchHelper.canonicalBookId(bookId);
    final list = pool
        .where((e) => HadithSearchHelper.canonicalBookId(e.bookId) == canonical)
        .map((e) => e.hadith)
        .skip(offset)
        .take(limit)
        .toList();
    return Right(list);
  }

  @override
  Future<Either<Failure, int>> countHadiths(String bookId, {String? gradeTier}) async =>
      Right(pool.length);

  @override
  Future<Either<Failure, HadithItem>> getHadithByNumber(String bookId, int number) async {
    final match = pool.where((e) => e.hadith.number == number).firstOrNull;
    return Right((match ?? pool.first).hadith);
  }

  @override
  Future<Either<Failure, DailyHadithEntry>> pickDailySahihHadith({
    int? seedOffset,
    String? excludeBook,
    int? excludeNumber,
  }) async {
    final sahihPool = pool
        .where(
          (e) =>
              e.hadith.gradeTier == HadithItem.tierMuttafaq ||
              e.hadith.gradeTier == HadithItem.tierSahih,
        )
        .toList();
    final filtered = sahihPool
        .where((e) => !(e.bookId == excludeBook && e.hadith.number == excludeNumber))
        .toList();
    final active = filtered.isNotEmpty ? filtered : sahihPool;
    final idx = (seedOffset ?? _rnd.nextInt(active.length)) % active.length;
    return Right(active[idx]);
  }

  @override
  Future<Either<Failure, Map<String, int>>> getBookCounts() async => const Right({});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  test('Bundled compressed SQLite catalog contains all 16,674 Hadiths', () async {
    final gzBytes = File('assets/hadith/hadith_catalog.db.gz').readAsBytesSync();
    final tempDir = await Directory.systemTemp.createTemp('hadith_gz_verify_');
    final dbFile = File('${tempDir.path}${Platform.pathSeparator}catalog.db');
    dbFile.writeAsBytesSync(gzip.decode(gzBytes), flush: true);

    final db = HadithCatalogDatabase.fromFile(dbFile);
    try {
      final books = await db.hadithDao.getBooks();
      final map = {for (final b in books) b.id: b.totalCount};
      expect(map['nawawi'], 42);
      expect(map['bukhari'], 7277);
      expect(map['muslim'], 7459);
      expect(map['riyad'], 1896);
    } finally {
      await db.close();
      await tempDir.delete(recursive: true);
    }
  });

  test('DailyHadithCubit persists pick per day and rotates on a new day', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final pool = List.generate(
      10,
      (i) => DailyHadithEntry(
        bookId: i.isEven ? 'sahih_bukhari' : 'riyad_assalihin',
        hadith: HadithItem(
          number: i + 1,
          title: 'حديث #${i + 1}',
          arabicText: 'نص حديث نبوي شريف رقم ${i + 1}',
          narrator: 'صحابي جليل',
          reference: 'مرجع ${i + 1}',
          gradeTier: i == 9 ? HadithItem.tierHasan : HadithItem.tierSahih,
          gradeLabelAr: i == 9 ? 'حديث حسن' : 'صحيح',
          gradeLabelEn: i == 9 ? 'Good (Hasan)' : 'Authentic (Sahih)',
          strengthScore: i == 9 ? 3 : 4,
        ),
      ),
    );
    final repo = _FakeHadithRepository(pool);
    final cubit = DailyHadithCubit(repository: repo, prefs: prefs, random: Random(42));

    final dayOne = DateTime(2026, 11, 28);
    await cubit.loadDailyHadith(now: dayOne);
    final dayOnePick = cubit.state.entry;
    expect(dayOnePick, isNotNull);
    expect(
      dayOnePick!.hadith.gradeTier,
      anyOf(HadithItem.tierMuttafaq, HadithItem.tierSahih),
    );

    final cubitReloaded = DailyHadithCubit(
      repository: repo,
      prefs: prefs,
      random: Random(99),
    );
    await cubitReloaded.loadDailyHadith(now: dayOne);
    expect(cubitReloaded.state.entry, equals(dayOnePick));

    final dayTwo = DateTime(2026, 11, 29);
    await cubitReloaded.loadDailyHadith(now: dayTwo);
    expect(cubitReloaded.state.entry, isNotNull);
    expect(cubitReloaded.state.entry, isNot(equals(dayOnePick)));

    await cubit.close();
    await cubitReloaded.close();
  });

  testWidgets('DailyHadithHighlightCard renders grade badge & shuffles on tap', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    const pool = [
      DailyHadithEntry(
        bookId: 'nawawi_forty',
        hadith: HadithItem(
          number: 1,
          title: 'النية',
          arabicText: 'إنما الأعمال بالنيات',
          narrator: 'عمر بن الخطاب',
          reference: 'الأربعون النووية (حديث 1)',
          gradeTier: HadithItem.tierMuttafaq,
          gradeLabelAr: 'صحيح • متفق عليه',
          gradeLabelEn: 'Sahih • Agreed Upon',
          strengthScore: 4,
        ),
      ),
      DailyHadithEntry(
        bookId: 'sahih_bukhari',
        hadith: HadithItem(
          number: 2,
          title: 'الكلمة الطيبة',
          arabicText: 'الكلمة الطيبة صدقة',
          narrator: 'أبو هريرة',
          reference: 'صحيح البخاري (حديث 2)',
        ),
      ),
    ];
    final cubit = DailyHadithCubit(
      repository: _FakeHadithRepository(pool),
      prefs: prefs,
      random: Random(7),
    );
    await cubit.loadDailyHadith(now: DateTime(2026, 11, 28));
    final firstText = cubit.state.entry!.hadith.arabicText;

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/lang',
        startLocale: const Locale('ar'),
        fallbackLocale: const Locale('ar'),
        assetLoader: const FileJsonAssetLoader(),
        child: Builder(
          builder: (context) => ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (_, _) => MaterialApp(
              theme: AppTheme.lightTheme,
              locale: const Locale('ar'),
              supportedLocales: context.supportedLocales,
              localizationsDelegates: [
                EasyLocalization.of(context)!.delegate,
                ...GlobalMaterialLocalizations.delegates,
              ],
              home: Scaffold(
                body: BlocProvider.value(
                  value: cubit,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: DailyHadithHighlightCard(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining(firstText), findsOneWidget);
    expect(find.text('4/4'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.autorenew_rounded));
    await tester.pumpAndSettle();
    expect(cubit.state.entry!.hadith.arabicText, isNot(firstText));

    await cubit.close();
  });

  testWidgets('HadithStrengthMeterCard displays 4 scholarly progression stages cleanly', (tester) async {
    const item = HadithItem(
      number: 1,
      title: 'النية',
      arabicText: 'إنما الأعمال بالنيات',
      narrator: 'عمر بن الخطاب',
      reference: 'الأربعون النووية',
      gradeTier: HadithItem.tierHasan,
      gradeLabelAr: 'حديث حسن',
      gradeLabelEn: 'Good (Hasan)',
      strengthScore: 3,
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/lang',
        startLocale: const Locale('ar'),
        fallbackLocale: const Locale('ar'),
        assetLoader: const FileJsonAssetLoader(),
        child: Builder(
          builder: (context) => ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (_, _) => MaterialApp(
              theme: AppTheme.lightTheme,
              locale: const Locale('ar'),
              supportedLocales: context.supportedLocales,
              localizationsDelegates: [
                EasyLocalization.of(context)!.delegate,
                ...GlobalMaterialLocalizations.delegates,
              ],
              home: const Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(16),
                  child: HadithStrengthMeterCard(hadith: item),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('3/4'), findsOneWidget);
    expect(find.text('تخريج'), findsOneWidget);
    expect(find.text('حسن'), findsOneWidget);
    expect(find.text('صحيح'), findsOneWidget);
    expect(find.text('متفق'), findsOneWidget);
  });
}
