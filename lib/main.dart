import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/di/injection_container.dart' as di;
import 'core/localization/localization_manager.dart';
import 'core/widgets/app_unfocus.dart';
import 'core/services/notification/notification_service.dart';
import 'core/services/notification/prayer_alarm_scheduler.dart';
import 'core/services/notification/azkar_alarm_scheduler.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependency injection
  await di.init();

  // Initialize notification service & permissions
  final notificationService = di.sl<NotificationService>();
  await notificationService.init(
    onNotificationTap: (response) {
      if (response.actionId == 'stop_adhan') {
        if (response.id != null) {
          notificationService.cancel(response.id!);
        }
        return;
      }
      final payload = response.payload;
      if (payload != null && payload.startsWith('adhan:')) {
        if (response.id != null) {
          notificationService.cancel(response.id!);
        }
        AppRouter.navigatorKey.currentState?.pushNamed(
          Routes.adhan,
          arguments: payload,
        );
      } else if (payload != null && payload.startsWith('azkar:')) {
        final categoryId = payload.split(':')[1];
        AppRouter.navigatorKey.currentState?.pushNamed(
          Routes.azkarCategory,
          arguments: {'categoryId': categoryId},
        );
      }
    },
  );
  await notificationService.requestPermissions();

  // Initial prayer & azkar alarm schedule
  try {
    final scheduler = di.sl<PrayerAlarmScheduler>();
    final azkarScheduler = di.sl<AzkarAlarmScheduler>();
    final settingsDs = di.sl<SettingsLocalDataSource>();
    final loc = settingsDs.getLocation();
    await scheduler.schedulePrayerAlarms(
      latitude: loc.lat,
      longitude: loc.lng,
      adhanEnabled:
          settingsDs.getPrayerNotification() && settingsDs.getAthanSound(),
      preAlertEnabled:
          settingsDs.getPrayerNotification() && settingsDs.getPrePrayerNotification(),
    );
    await azkarScheduler.scheduleDailyAzkar(
      enabled: settingsDs.getAzkarNotification(),
    );
  } catch (_) {
    // Background scheduling init fallback
  }

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      fallbackLocale: LocalizationManager.fallbackLocale,
      startLocale: LocalizationManager.fallbackLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ThemeCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                navigatorKey: AppRouter.navigatorKey,
                title: 'Zad Al-Muslim',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                initialRoute: Routes.splash,
                onGenerateRoute: AppRouter.generateRoute,
                localizationsDelegates: [
                  EasyLocalization.of(context)!.delegate,
                  ...GlobalMaterialLocalizations.delegates,
                ],
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                builder: (context, child) {
                  return AppUnfocus(child: child ?? const SizedBox.shrink());
                },
              );
            },
          );
        },
      ),
    );
  }
}
