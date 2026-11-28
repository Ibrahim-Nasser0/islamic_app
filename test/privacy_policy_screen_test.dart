import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/config/app_config.dart';
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/theme/app_theme.dart';
import 'package:islamic_app/features/settings/presentation/views/widgets/settings_about_card.dart';
import 'package:islamic_app/features/settings/views/privacy_policy_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/home_layout_fakes.dart';

Widget _wrapWithApp({required Widget home, Locale locale = const Locale('ar')}) {
  return EasyLocalization(
    supportedLocales: const [Locale('ar'), Locale('en')],
    path: 'assets/lang',
    startLocale: locale,
    fallbackLocale: const Locale('ar'),
    assetLoader: const FileJsonAssetLoader(),
    child: Builder(
      builder: (context) => ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: [
            EasyLocalization.of(context)!.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          onGenerateRoute: AppRouter.generateRoute,
          home: home,
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('PrivacyPolicyScreen renders all privacy sections in Arabic cleanly', (tester) async {
    final errors = <FlutterErrorDetails>[];
    final prev = FlutterError.onError;
    FlutterError.onError = errors.add;
    try {
      await tester.pumpWidget(_wrapWithApp(home: const PrivacyPolicyScreen()));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(errors, isEmpty);
      expect(find.text('privacy_policy_title'.tr()), findsOneWidget);
      expect(find.text('privacy_hero_title'.tr()), findsOneWidget);
      expect(find.text('privacy_sec1_title'.tr()), findsOneWidget);
      expect(find.text('privacy_sec2_title'.tr()), findsOneWidget);
      expect(find.text(AppConfig.developerEmail), findsOneWidget);
    } finally {
      FlutterError.onError = prev;
    }
  });

  testWidgets('SettingsAboutCard navigates to PrivacyPolicyScreen when tapped', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        locale: const Locale('en'),
        home: const Scaffold(
          body: SingleChildScrollView(child: SettingsAboutCard()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final link = find.text('privacy_policy_title'.tr());
    expect(link, findsOneWidget);
    await tester.tap(link);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
  });
}
