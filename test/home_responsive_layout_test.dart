import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
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
import 'package:islamic_app/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:islamic_app/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:islamic_app/features/quran/domain/repositories/quran_repository.dart';
import 'package:islamic_app/features/quran/presentation/cubit/daily_wird_cubit.dart';
import 'package:islamic_app/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:islamic_app/features/settings/data/datasources/settings_local_data_source.dart';
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
    di.sl.registerFactory(() => TimedAzkarCubit(di.sl()));
    di.sl.registerLazySingleton(() => DailyWirdCubit(settingsDs: di.sl()));
    di.sl.registerLazySingleton<QuranLocalDataSource>(
      () => QuranLocalDataSourceImpl(),
    );
    di.sl.registerLazySingleton<QuranRepository>(
      () => QuranRepositoryImpl(localDataSource: di.sl()),
    );
    di.sl.registerFactory(() => QuranCubit(repository: di.sl()));
  });

  tearDown(() async {
    await di.sl.reset();
  });

  Future<void> pumpHomeAtViewport(
    WidgetTester tester, {
    required Size size,
    required Locale locale,
    double textScale = 1.0,
    required bool expectNavRail,
  }) async {
    final capturedErrors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = capturedErrors.add;

    try {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;

      final designSize = size.width > 450
          ? Size(size.width / 1.15, size.height / 1.15)
          : const Size(375, 812);

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('ar'), Locale('en')],
          path: 'assets/lang',
          startLocale: locale,
          fallbackLocale: const Locale('ar'),
          assetLoader: const FileJsonAssetLoader(),
          child: Builder(
            builder: (context) => ScreenUtilInit(
              designSize: designSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, _) => MaterialApp(
                theme: AppTheme.lightTheme,
                locale: locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                builder: (ctx, child) => MediaQuery(
                  data: MediaQuery.of(ctx).copyWith(
                    textScaler: TextScaler.linear(textScale),
                  ),
                  child: child!,
                ),
                home: const HomeScreen(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        capturedErrors,
        isEmpty,
        reason: 'Unexpected FlutterErrors at $size ($locale, x$textScale): '
            '${capturedErrors.map((e) => e.exceptionAsString()).join('\n')}',
      );

      expect(
        find.byType(NavigationRail),
        expectNavRail ? findsOneWidget : findsNothing,
      );

      // Clear widget tree cleanly so timers (e.g. PrayerTimesCubit) dispose.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    } finally {
      FlutterError.onError = previousOnError;
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }
  }

  const viewports = [
    (name: 'compact narrow 320x568', size: Size(320, 568), scale: 1.0, rail: false),
    (name: 'compact 375x812 @ 1.25x', size: Size(375, 812), scale: 1.25, rail: false),
    (name: 'medium portrait 768x1024', size: Size(768, 1024), scale: 1.0, rail: true),
    (name: 'expanded landscape 1024x768', size: Size(1024, 768), scale: 1.0, rail: true),
  ];

  for (final vp in viewports) {
    for (final locale in const [Locale('ar'), Locale('en')]) {
      testWidgets(
        'HomeScreen renders without overflow on ${vp.name} (${locale.languageCode})',
        (tester) async {
          await pumpHomeAtViewport(
            tester,
            size: vp.size,
            locale: locale,
            textScale: vp.scale,
            expectNavRail: vp.rail,
          );
        },
      );
    }
  }
}
