import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/services/location_preference_service.dart';
import 'package:islamic_app/core/theme/app_theme.dart';
import 'package:islamic_app/core/widgets/dialogs/dialogs.dart';
import 'package:islamic_app/features/home/data/datasources/city_resolver_helper.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/home_layout_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  group('Auto-Location Resolution & Caching', () {
    test('CityResolverHelper resolves known cities bilingually within 35km', () async {
      final alex = await CityResolverHelper.resolveCity(
        latitude: 31.21,
        longitude: 29.93,
      );
      expect(alex.nameAr, 'الإسكندرية، مصر');
      expect(alex.nameEn, 'Alexandria, Egypt');

      final makkah = await CityResolverHelper.resolveCity(
        latitude: 21.425,
        longitude: 39.825,
      );
      expect(makkah.nameAr, 'مكة المكرمة');
      expect(makkah.nameEn, 'Makkah');

      final remote = await CityResolverHelper.resolveCity(
        latitude: 0.0,
        longitude: 0.0,
      );
      expect(remote.nameEn, '0.00, 0.00');
    });

    test('LocationPreferenceService caches GPS location and restores after manual reset', () async {
      SharedPreferences.setMockInitialValues({});
      await LocationPreferenceService.cacheGpsLocation(
        latitude: 31.2001,
        longitude: 29.9187,
        nameAr: 'الإسكندرية، مصر',
        nameEn: 'Alexandria, Egypt',
      );

      final cached = await LocationPreferenceService.getFastCachedActiveLocation();
      expect(cached.isManual, isFalse);
      expect(cached.nameEn, 'Alexandria, Egypt');

      await LocationPreferenceService.setManualLocation(
        latitude: 21.4225,
        longitude: 39.8262,
        nameAr: 'مكة المكرمة',
        nameEn: 'Makkah',
      );
      final manual = await LocationPreferenceService.getFastCachedActiveLocation();
      expect(manual.isManual, isTrue);
      expect(manual.nameAr, 'مكة المكرمة');

      await LocationPreferenceService.resetToGps();
      final reverted = await LocationPreferenceService.getFastCachedActiveLocation();
      expect(reverted.isManual, isFalse);
      expect(reverted.nameEn, 'Alexandria, Egypt');
    });
  });

  group('Sanctuary Custom Dialogs', () {
    Future<void> pumpDialog(WidgetTester tester, Widget dialog) async {
      final errors = <FlutterErrorDetails>[];
      final prev = FlutterError.onError;
      FlutterError.onError = errors.add;
      try {
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
                  home: Scaffold(body: Center(child: dialog)),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(errors, isEmpty);
      } finally {
        FlutterError.onError = prev;
      }
    }

    testWidgets('Loading dialog uses mosque crest without asset errors', (tester) async {
      await pumpDialog(tester, const CustomLoadingDialog(title: 'جاري التحديث'));
      expect(find.byIcon(FlutterIslamicIcons.solidMosque), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('Success, Confirm, and Failure dialogs render cleanly', (tester) async {
      await pumpDialog(
        tester,
        const CustomSuccessDialog(title: 'تم الحفظ', message: 'تم تحديث الموقع بنجاح'),
      );
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      await pumpDialog(
        tester,
        const CustomConfirmDialog(
          title: 'تنبيه الموقع',
          message: 'يرجى تفعيل GPS',
          confirmText: 'open_settings',
          cancelText: 'cancel',
        ),
      );
      expect(find.text('open_settings'.tr()), findsOneWidget);

      await pumpDialog(
        tester,
        const CustomFailureDialog(title: 'خطأ', message: 'تعذر الاتصال'),
      );
      expect(find.text('خطأ'), findsOneWidget);
    });
  });
}
