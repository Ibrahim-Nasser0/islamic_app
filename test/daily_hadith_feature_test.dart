import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/errors/failure.dart';
import 'package:islamic_app/core/theme/app_theme.dart';
import 'package:islamic_app/features/hadith/domain/entities/daily_hadith_entry.dart';
import 'package:islamic_app/features/hadith/domain/entities/hadith_item.dart';
import 'package:islamic_app/features/hadith/domain/repositories/hadith_repository.dart';
import 'package:islamic_app/features/hadith/presentation/cubit/daily_hadith_cubit.dart';
import 'package:islamic_app/features/home/views/widgets/daily_hadith_highlight_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/home_layout_fakes.dart';

class _FakeHadithRepository implements HadithRepository {
  final List<DailyHadithEntry> pool;
  _FakeHadithRepository(this.pool);

  @override
  Future<Either<Failure, List<DailyHadithEntry>>> getAllHadithsPool() async =>
      Right(pool);

  @override
  Future<Either<Failure, HadithItem>> getHadithByNumber(
    String bookId,
    int number,
  ) async =>
      Right(pool.first.hadith);

  @override
  Future<Either<Failure, List<HadithItem>>> getHadithsByBook(
    String bookId,
  ) async =>
      Right(pool.where((e) => e.bookId == bookId).map((e) => e.hadith).toList());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  test('Bundled compressed JSON books contain expanded Hadith collections (42 + 3x500)', () {
    final counts = <String, int>{};
    for (final name in ['nawawi', 'bukhari', 'muslim', 'riyad']) {
      final rawBytes = File('assets/hadith/$name.json.gz').readAsBytesSync();
      final jsonStr = utf8.decode(gzip.decode(rawBytes));
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      counts[name] = decoded.length;
    }
    expect(counts['nawawi'], 42);
    expect(counts['bukhari'], 500);
    expect(counts['muslim'], 500);
    expect(counts['riyad'], 500);
  });

  test('DailyHadithCubit persists pick per day and rotates on a new day', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final pool = List.generate(
      10,
      (i) => DailyHadithEntry(
        bookId: i.isEven ? 'bukhari' : 'riyad',
        hadith: HadithItem(
          number: i + 1,
          title: 'حديث #${i + 1}',
          arabicText: 'نص حديث نبوي شريف رقم ${i + 1}',
          narrator: 'صحابي جليل',
          reference: 'مرجع ${i + 1}',
        ),
      ),
    );
    final repo = _FakeHadithRepository(pool);
    final cubit = DailyHadithCubit(
      repository: repo,
      prefs: prefs,
      random: Random(42),
    );

    final dayOne = DateTime(2026, 11, 28);
    await cubit.loadDailyHadith(now: dayOne);
    final dayOnePick = cubit.state.entry;
    expect(dayOnePick, isNotNull);

    // Reloading on the same day restores the exact same Hadith.
    final cubitReloaded = DailyHadithCubit(
      repository: repo,
      prefs: prefs,
      random: Random(99),
    );
    await cubitReloaded.loadDailyHadith(now: dayOne);
    expect(cubitReloaded.state.entry, equals(dayOnePick));

    // A new calendar day triggers a new random pick different from yesterday's.
    final dayTwo = DateTime(2026, 11, 29);
    await cubitReloaded.loadDailyHadith(now: dayTwo);
    expect(cubitReloaded.state.entry, isNotNull);
    expect(cubitReloaded.state.entry, isNot(equals(dayOnePick)));

    await cubit.close();
    await cubitReloaded.close();
  });

  testWidgets('DailyHadithHighlightCard renders loaded Hadith & shuffles on tap', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final pool = [
      const DailyHadithEntry(
        bookId: 'nawawi',
        hadith: HadithItem(
          number: 1,
          title: 'النية',
          arabicText: 'إنما الأعمال بالنيات',
          narrator: 'عمر بن الخطاب',
          reference: 'الأربعون النووية (حديث 1)',
        ),
      ),
      const DailyHadithEntry(
        bookId: 'bukhari',
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
    await tester.tap(find.byIcon(Icons.autorenew_rounded));
    await tester.pumpAndSettle();
    expect(cubit.state.entry!.hadith.arabicText, isNot(firstText));

    await cubit.close();
  });
}
