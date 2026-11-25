import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_info.dart';
import '../api/api_interceptors.dart';
import '../config/app_config.dart';
import '../database/app_database.dart';
import '../database/daos/azkar_dao.dart';
import '../database/daos/quran_dao.dart';
import '../database/daos/tasbeeh_dao.dart';
import '../database/shared_prefs_migrator.dart';
import '../theme/theme_cubit.dart';
import '../services/native/native_alarm_bridge_service.dart';
import '../services/native/native_sync_coordinator.dart';
import '../services/native/permission_readiness_cubit.dart';
import '../services/notification/notification_service.dart';
import '../services/notification/prayer_alarm_scheduler.dart';
import '../services/notification/azkar_alarm_scheduler.dart';
import '../../features/home/data/datasources/location_service.dart';
import '../../features/home/data/datasources/prayer_calculation_service.dart';
import '../../features/home/data/repositories/prayer_repository_impl.dart';
import '../../features/home/domain/repositories/prayer_repository.dart';
import '../../features/home/presentation/cubit/prayer_times_cubit.dart';
import '../../features/qibla/presentation/cubit/qibla_cubit.dart';
import '../../features/quran/data/datasources/quran_local_data_source.dart';
import '../../features/quran/data/repositories/quran_repository_impl.dart';
import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/presentation/cubit/daily_wird_cubit.dart';
import '../../features/quran/presentation/cubit/quran_cubit.dart';
import '../../features/azkar/data/datasources/azkar_local_data_source.dart';
import '../../features/azkar/data/repositories/azkar_repository_impl.dart';
import '../../features/azkar/domain/repositories/azkar_repository.dart';
import '../../features/azkar/presentation/cubit/azkar_cubit.dart';
import '../../features/azkar/presentation/cubit/timed_azkar_cubit.dart';
import '../../features/hadith/data/datasources/hadith_local_data_source.dart';
import '../../features/hadith/data/repositories/hadith_repository_impl.dart';
import '../../features/hadith/domain/repositories/hadith_repository.dart';
import '../../features/hadith/presentation/cubit/hadith_cubit.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/tasbeeh/data/datasources/tasbeeh_local_data_source.dart';
import '../../features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';
import '../../features/mosques/data/datasources/mosques_remote_data_source.dart';
import '../../features/mosques/data/repositories/mosques_repository_impl.dart';
import '../../features/mosques/domain/repositories/mosques_repository.dart';
import '../../features/mosques/presentation/cubit/mosques_cubit.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  //! External Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //! Local Database (Drift) + One-time Migration
  final appDb = AppDatabase();
  sl.registerLazySingleton<AppDatabase>(() => appDb);
  sl.registerLazySingleton<TasbeehDao>(() => appDb.tasbeehDao);
  sl.registerLazySingleton<QuranDao>(() => appDb.quranDao);
  sl.registerLazySingleton<AzkarDao>(() => appDb.azkarDao);
  await SharedPrefsToDriftMigrator.migrateIfNeeded(appDb, sharedPreferences);

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));

  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(ApiInterceptor());

    // Add pretty logger in debug mode
    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    return dio;
  });

  // Prayer Times Feature
  sl.registerLazySingleton<PrayerCalculationService>(() => PrayerCalculationService());
  sl.registerLazySingleton<LocationService>(() => LocationService());
  sl.registerLazySingleton<PrayerRepository>(() => PrayerRepositoryImpl(
        calculationService: sl(),
        locationService: sl(),
      ));
  sl.registerFactory(
    () => PrayerTimesCubit(sl(), alarmScheduler: sl(), settingsDs: sl()),
  );
  sl.registerFactory(() => QiblaCubit(sl()));

  // Quran Feature
  sl.registerLazySingleton<QuranLocalDataSource>(
      () => QuranLocalDataSourceImpl(quranDao: sl()));
  sl.registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl(localDataSource: sl()));
  sl.registerFactory(() => QuranCubit(repository: sl()));
  sl.registerLazySingleton(() => DailyWirdCubit(settingsDs: sl()));

  // Azkar Feature
  sl.registerLazySingleton<AzkarLocalDataSource>(
      () => AzkarLocalDataSourceImpl(azkarDao: sl()));
  sl.registerLazySingleton<AzkarRepository>(() => AzkarRepositoryImpl(localDataSource: sl()));
  sl.registerFactory(() => AzkarCubit(repository: sl(), syncCoordinator: sl()));
  sl.registerFactory(() => TimedAzkarCubit(sl()));

  // Hadith Feature
  sl.registerLazySingleton<HadithLocalDataSource>(() => HadithLocalDataSourceImpl());
  sl.registerLazySingleton<HadithRepository>(() => HadithRepositoryImpl(localDataSource: sl()));
  sl.registerFactory(() => HadithCubit(repository: sl()));

  // Settings & Native Alarms
  sl.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(sl(), quranDao: sl(), tasbeehDao: sl()));
  sl.registerLazySingleton<NativeAlarmBridgeService>(
      () => NativeAlarmBridgeService());
  sl.registerLazySingleton<NativeSyncCoordinator>(
      () => NativeSyncCoordinator(bridge: sl(), azkarLocalDataSource: sl()));
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<PrayerAlarmScheduler>(
      () => PrayerAlarmScheduler(calculationService: sl(), nativeBridge: sl()));
  sl.registerLazySingleton<AzkarAlarmScheduler>(
      () => AzkarAlarmScheduler(nativeBridge: sl()));
  sl.registerFactory(() => SettingsCubit(
        sl(),
        alarmScheduler: sl(),
        azkarScheduler: sl(),
        nativeBridge: sl(),
      ));
  sl.registerFactory(() => PermissionReadinessCubit(
        bridge: sl(),
        notificationService: sl(),
        prayerScheduler: sl(),
        azkarScheduler: sl(),
        settingsDs: sl(),
      ));

  // Mosques Feature
  sl.registerLazySingleton<MosquesRemoteDataSource>(
      () => MosquesRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<MosquesRepository>(
      () => MosquesRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory(() => MosquesCubit(repository: sl()));

  // Tasbeeh Feature
  final tasbeehDs = TasbeehLocalDataSourceImpl(sl(), tasbeehDao: sl());
  await tasbeehDs.warmUp();
  sl.registerLazySingleton<TasbeehLocalDataSource>(() => tasbeehDs);
  sl.registerFactory(() => TasbeehCubit(localDs: sl()));
}
