import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/services/native/permission_readiness_cubit.dart';
import 'package:islamic_app/core/services/native/permission_readiness_state.dart';
import 'package:islamic_app/core/theme/app_theme.dart';
import 'package:islamic_app/core/widgets/permissions_checklist_sheet.dart';
import 'package:islamic_app/features/home/views/widgets/kaaba_atmospheric_hero_card.dart';
import 'package:islamic_app/features/settings/data/datasources/settings_location_store.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/home_layout_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  test('PermissionReadinessState computes missingCount and readiness accurately', () {
    const partial = PermissionReadinessState(
      notificationsGranted: true,
      locationGranted: true,
      exactAlarmsGranted: false,
      fullScreenIntentGranted: false,
      batteryUnrestricted: true,
    );
    expect(partial.isCoreReady, isTrue);
    expect(partial.missingCount, 2);
    expect(partial.isAllReady, isFalse);
    expect(partial.isAdhanOptimal, isFalse);

    const ready = PermissionReadinessState(
      notificationsGranted: true,
      locationGranted: true,
      exactAlarmsGranted: true,
      fullScreenIntentGranted: true,
      batteryUnrestricted: true,
    );
    expect(ready.missingCount, 0);
    expect(ready.isAllReady, isTrue);
    expect(ready.isAdhanOptimal, isTrue);
  });

  test('SettingsLocationStore uses cached GPS city when automatic mode is active', () async {
    SharedPreferences.setMockInitialValues({
      'is_manual_location': false,
      'last_gps_lat': 31.2001,
      'last_gps_lng': 29.9187,
      'last_gps_name_ar': 'الإسكندرية، مصر',
      'last_gps_name_en': 'Alexandria, Egypt',
    });
    final prefs = await SharedPreferences.getInstance();
    final loc = SettingsLocationStore.getLocation(prefs);
    expect(loc.isManual, isFalse);
    expect(loc.lat, closeTo(31.2001, 0.001));
    expect(loc.nameEn, 'Alexandria, Egypt');
  });

  testWidgets('PermissionsChecklistSheet & HeroCard with track render without overflow', (tester) async {
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
                home: Scaffold(
                  body: BlocProvider<PermissionReadinessCubit>.value(
                    value: StubPermissionReadinessCubit(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: const [
                          KaabaAtmosphericHeroCard(
                            location: 'الإسكندرية، مصر',
                            prevPrayerLabel: 'الشروق 06:12 ص',
                            nextPrayerName: 'الظهر',
                            nextPrayerTime: '11:50 ص',
                            remainingTime: '01:12:08',
                            intervalProgress: 0.65,
                          ),
                          PermissionsChecklistSheet(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(errors, isEmpty);
      expect(find.text('perm_fullscreen_title'.tr()), findsOneWidget);
      expect(find.text('perm_battery_title'.tr()), findsOneWidget);
    } finally {
      FlutterError.onError = prev;
    }
  });
}
