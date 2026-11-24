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
import 'core/services/native/native_sync_coordinator.dart';
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

  // Bind native lockscreen deep links & initialize notifications safely without blocking launch
  final syncCoordinator = di.sl<NativeSyncCoordinator>();
  syncCoordinator.bindForegroundRouteHandler();

  final notificationService = di.sl<NotificationService>();
  try {
    await notificationService
        .init(
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
              return;
            }
            if (notificationService.didNotificationLaunchApp) return;
            if (payload != null && payload.startsWith('azkar:')) {
              final parts = payload.split(':');
              if (parts.length > 1) {
                AppRouter.navigatorKey.currentState?.pushNamed(
                  Routes.azkarCategory,
                  arguments: {'categoryId': parts[1]},
                );
              }
            }
          },
        )
        .timeout(const Duration(seconds: 2));
  } catch (_) {
    // Keep startup resilient if platform notification init is delayed
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

  // Run permissions, Dhikr sync, and alarm scheduling only after first frame renders
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _bootstrapPostFrameServices(
      syncCoordinator: syncCoordinator,
      notificationService: notificationService,
    );
  });
}

Future<void> _bootstrapPostFrameServices({
  required NativeSyncCoordinator syncCoordinator,
  required NotificationService notificationService,
}) async {
  try {
    await syncCoordinator.syncPendingDhikrUpdates();
  } catch (_) {}

  try {
    await notificationService.requestPermissions();
  } catch (_) {}

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
      preAlertEnabled: settingsDs.getPrayerNotification() &&
          settingsDs.getPrePrayerNotification(),
    );
    await azkarScheduler.scheduleDailyAzkar(
      enabled: settingsDs.getAzkarNotification(),
    );
  } catch (_) {}
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
