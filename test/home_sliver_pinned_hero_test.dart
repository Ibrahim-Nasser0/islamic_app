import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/di/injection_container.dart' as di;
import 'package:islamic_app/core/services/native/permission_readiness_cubit.dart';
import 'package:islamic_app/core/theme/app_theme.dart';
import 'package:islamic_app/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:islamic_app/features/azkar/presentation/cubit/timed_azkar_cubit.dart';
import 'package:islamic_app/features/home/domain/repositories/prayer_repository.dart';
import 'package:islamic_app/features/home/presentation/cubit/prayer_times_cubit.dart';
import 'package:islamic_app/features/home/views/home_screen.dart';
import 'package:islamic_app/features/home/views/widgets/compact_pinned_hero_card.dart';
import 'package:islamic_app/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:islamic_app/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:islamic_app/features/quran/domain/repositories/quran_repository.dart';
import 'package:islamic_app/features/quran/presentation/cubit/daily_wird_cubit.dart';
import 'package:islamic_app/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:islamic_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/home_layout_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    await di.sl.reset();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    di.sl.registerLazySingleton<SharedPreferences>(() => prefs);
    di.sl.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(prefs),
    );
    di.sl.registerLazySingleton<PrayerRepository>(() => FakePrayerRepository());
    di.sl.registerFactory(() => PrayerTimesCubit(di.sl()));
    di.sl.registerFactory<PermissionReadinessCubit>(
      () => StubPermissionReadinessCubit(),
    );
    di.sl.registerLazySingleton<AzkarLocalDataSource>(
      () => FakeAzkarLocalDataSource(),
    );
    di.sl.registerLazySingleton(() => TimedAzkarCubit(di.sl()));
    di.sl.registerLazySingleton(() => DailyWirdCubit(settingsDs: di.sl()));
    di.sl.registerLazySingleton<QuranLocalDataSource>(
      () => QuranLocalDataSourceImpl(),
    );
    di.sl.registerLazySingleton<QuranRepository>(
      () => QuranRepositoryImpl(localDataSource: di.sl()),
    );
    di.sl.registerFactory(() => QuranCubit(repository: di.sl()));
  });

  tearDown(() async => di.sl.reset());

  testWidgets(
      'CustomScrollView reveals CompactPinnedHeroCard only after scrolling past full Hero Card',
      (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

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
              home: const HomeScreen(),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final initialCompact = tester.widget<CompactPinnedHeroCard>(
      find.byType(CompactPinnedHeroCard),
    );
    expect(initialCompact.visible, isFalse);

    await tester.drag(find.byType(CustomScrollView).first, const Offset(0, -500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final scrolledCompact = tester.widget<CompactPinnedHeroCard>(
      find.byType(CompactPinnedHeroCard),
    );
    expect(scrolledCompact.visible, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
