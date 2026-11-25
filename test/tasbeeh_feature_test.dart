import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/di/injection_container.dart' as di;
import 'package:islamic_app/core/theme/app_theme.dart';
import 'package:islamic_app/features/tasbeeh/data/datasources/tasbeeh_local_data_source.dart';
import 'package:islamic_app/features/tasbeeh/domain/entities/tasbeeh_feedback_mode.dart';
import 'package:islamic_app/features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';
import 'package:islamic_app/features/tasbeeh/views/tasbeeh_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/home_layout_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  group('TasbeehCubit & Persistence', () {
    test('tracks cycle 33 milestone, undo -1, feedback mode, and persists state', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final ds = TasbeehLocalDataSourceImpl(prefs);
      final cubit = TasbeehCubit(localDs: ds);

      for (var i = 0; i < 33; i++) {
        cubit.increment();
      }
      expect(cubit.state.cycleCount, 33);
      expect(cubit.state.currentRound, 1);
      expect(cubit.state.progress, 1.0);
      expect(cubit.state.isTargetReached, isTrue);

      cubit.increment();
      expect(cubit.state.cycleCount, 1);
      expect(cubit.state.currentRound, 2);

      cubit.decrement();
      expect(cubit.state.currentItem.currentCount, 33);
      expect(cubit.state.lifetimeTotal, 33);

      cubit.setTarget(99);
      cubit.cycleFeedbackMode();
      expect(cubit.state.feedbackMode, TasbeehFeedbackMode.soundAndHaptic);
      await cubit.close();

      // Reload from SharedPreferences
      final reloaded = TasbeehCubit(localDs: TasbeehLocalDataSourceImpl(prefs));
      expect(reloaded.state.currentItem.currentCount, 33);
      expect(reloaded.state.lifetimeTotal, 33);
      expect(reloaded.state.target, 99);
      expect(reloaded.state.feedbackMode, TasbeehFeedbackMode.soundAndHaptic);
      await reloaded.close();
    });

    test('handles disabling all Wird items safely and resets Wird on a new day', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final ds = TasbeehLocalDataSourceImpl(prefs);
      final cubit = TasbeehCubit(localDs: ds);

      cubit.incrementWird();
      expect(cubit.state.activeWirdItem!.currentCount, 1);
      cubit.decrementWird();
      expect(cubit.state.activeWirdItem!.currentCount, 0);

      for (final item in cubit.state.wirdItems) {
        cubit.toggleWirdItem(item.id, false);
      }
      expect(cubit.state.enabledWirdItems, isEmpty);
      expect(cubit.state.activeWirdItem, isNull);

      cubit.addCustomWirdItem('اللهم اغفر لي', 50);
      expect(cubit.state.enabledWirdItems.length, 1);
      await cubit.close();

      final nextDaySnap = ds.loadSnapshot(now: DateTime(2099, 1, 2));
      expect(nextDaySnap.wirdItems.any((i) => i.arabicText == 'اللهم اغفر لي'), isTrue);
      expect(nextDaySnap.wirdItems.every((i) => i.currentCount == 0), isTrue);
    });
  });

  group('TasbeehScreen Responsive Layout', () {
    setUp(() async {
      await di.sl.reset();
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      di.sl.registerLazySingleton<TasbeehLocalDataSource>(
        () => TasbeehLocalDataSourceImpl(prefs),
      );
      di.sl.registerFactory(() => TasbeehCubit(localDs: di.sl()));
    });

    tearDown(() async => di.sl.reset());

    Future<void> pumpTasbeehAt(
      WidgetTester tester,
      Size size,
      Locale locale, {
      double textScale = 1.0,
    }) async {
      final errors = <FlutterErrorDetails>[];
      final prev = FlutterError.onError;
      FlutterError.onError = errors.add;
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
                  localizationsDelegates: [
                    EasyLocalization.of(context)!.delegate,
                    ...GlobalMaterialLocalizations.delegates,
                  ],
                  builder: (ctx, child) => MediaQuery(
                    data: MediaQuery.of(ctx).copyWith(
                      textScaler: TextScaler.linear(textScale),
                    ),
                    child: child!,
                  ),
                  home: const TasbeehScreen(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));

        // Switch to Daily Wird tab and pump again
        await tester.tap(find.text('daily_wird'.tr()));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));

        expect(
          errors,
          isEmpty,
          reason: 'TasbeehScreen errors at $size ($locale): '
              '${errors.map((e) => e.exceptionAsString()).join('\n')}',
        );
      } finally {
        FlutterError.onError = prev;
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      }
    }

    for (final vp in const [
      (size: Size(320, 568), scale: 1.0, label: '320x568'),
      (size: Size(375, 812), scale: 1.25, label: '375x812@1.25x'),
      (size: Size(1024, 768), scale: 1.0, label: '1024x768'),
    ]) {
      for (final locale in const [Locale('ar'), Locale('en')]) {
        testWidgets(
          'renders Free & Wird modes without overflow at ${vp.label} (${locale.languageCode})',
          (tester) => pumpTasbeehAt(
            tester,
            vp.size,
            locale,
            textScale: vp.scale,
          ),
        );
      }
    }
  });
}
