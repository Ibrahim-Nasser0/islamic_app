import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../../../features/settings/presentation/models/muadhin_option.dart';
import '../native/native_alarm_bridge_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool didNotificationLaunchApp = false;
  String? pendingPayload;

  String? consumePendingPayload() {
    final payload = pendingPayload;
    pendingPayload = null;
    didNotificationLaunchApp = false;
    return payload;
  }

  static const String adhanChannelId = 'prayer_adhan_channel';
  static const String adhanChannelName = 'الأذان ومواقيت الصلاة';
  static const String adhanChannelDesc = 'تنبيهات وقت الصلاة الفعلي والأذان الكامل';

  static const String preChannelId = 'prayer_pre_channel';
  static const String preChannelName = 'تنبيه ما قبل الصلاة (5 دقائق)';
  static const String preChannelDesc = 'تنبيه استباقي للاستعداد والوضوء';

  static const String azkarChannelId = 'prayer_azkar_channel';
  static const String azkarChannelName = 'أذكار الصباح والمساء';
  static const String azkarChannelDesc = 'تنبيهات الأذكار اليومية والأدعية النبوية';

  Future<void> init({void Function(NotificationResponse)? onNotificationTap}) async {
    // 1. Initialize Timezones
    tz.initializeTimeZones();

    // 2. Android Initialization Settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_stat_mosque');

    // 3. iOS Initialization Settings
    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    if (!Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
      );

      final launchDetails = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        didNotificationLaunchApp = true;
        pendingPayload = launchDetails?.notificationResponse?.payload;
        final launchId = launchDetails?.notificationResponse?.id;
        if (pendingPayload != null &&
            pendingPayload!.startsWith('adhan:') &&
            launchId != null) {
          await cancel(launchId);
        }
      }
    }

    // 4. Create Android Notification Channels without blocking cold startup
    if (Platform.isAndroid) {
      unawaited(_createNotificationChannels().catchError((_) {}));
    }
  }

  Future<void> _createNotificationChannels() async {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      const AndroidNotificationChannel preChannel = AndroidNotificationChannel(
        preChannelId,
        preChannelName,
        description: preChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );
      await androidPlugin.createNotificationChannel(preChannel);

      const AndroidNotificationChannel azkarChannel = AndroidNotificationChannel(
        azkarChannelId,
        azkarChannelName,
        description: azkarChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );
      await androidPlugin.createNotificationChannel(azkarChannel);

      // Create distinct channels for each muezzin and prayer mode
      for (final muezzin in MuadhinOption.defaultList) {
        for (final isFajr in [false, true]) {
          final channelId = muezzin.getChannelId(isFajr: isFajr);
          final rawSound = muezzin.getRawSound(isFajr: isFajr);
          final sound = RawResourceAndroidNotificationSound(rawSound);

          final adhanChannel = AndroidNotificationChannel(
            channelId,
            'أذان ${muezzin.location} (${isFajr ? 'الفجر' : 'العام'})',
            description: 'تشغيل أذان ${muezzin.location} تلقائياً',
            importance: Importance.max,
            playSound: true,
            sound: sound,
            enableVibration: true,
            audioAttributesUsage: AudioAttributesUsage.alarm,
          );
          await androidPlugin.createNotificationChannel(adhanChannel);
        }
      }
    }
  }

  Future<void> cancel(int id) async {
    if (Platform.isIOS) return;
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (_) {
      // Ignored when plugin platform isn't initialized (e.g. headless unit tests)
    }
  }

  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final nativeGranted =
            await const NativeAlarmBridgeService().requestNotificationPermission();
        if (nativeGranted) return true;
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        return await androidPlugin?.requestNotificationsPermission() ?? false;
      } else if (Platform.isIOS) {
        return await const NativeAlarmBridgeService().requestIosPermissions();
      }
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<bool> requestExactAlarmsPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.requestExactAlarmsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelAll() async {
    if (Platform.isIOS) return;
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (_) {}
  }

  Future<bool> canScheduleExactAlarms() async {
    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.canScheduleExactNotifications() ?? true;
    }
    return true;
  }
}

