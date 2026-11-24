import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? pendingPayload;

  String? consumePendingPayload() {
    final payload = pendingPayload;
    pendingPayload = null;
    return payload;
  }

  static const String adhanChannelId = 'prayer_adhan_channel';
  static const String adhanChannelName = 'الأذان ومواقيت الصلاة';
  static const String adhanChannelDesc = 'تنبيهات وقت الصلاة الفعلي والأذان الكامل';

  static const String preChannelId = 'prayer_pre_channel';
  static const String preChannelName = 'تنبيه ما قبل الصلاة (5 دقائق)';
  static const String preChannelDesc = 'تنبيه استباقي للاستعداد والوضوء';

  Future<void> init({void Function(NotificationResponse)? onNotificationTap}) async {
    // 1. Initialize Timezones
    tz.initializeTimeZones();

    // 2. Android Initialization Settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    final launchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      pendingPayload = launchDetails?.notificationResponse?.payload;
    }

    // 4. Create Android Notification Channels
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  Future<void> _createNotificationChannels() async {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      const AndroidNotificationChannel adhanChannel = AndroidNotificationChannel(
        adhanChannelId,
        adhanChannelName,
        description: adhanChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      const AndroidNotificationChannel preChannel = AndroidNotificationChannel(
        preChannelId,
        preChannelName,
        description: preChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await androidPlugin.createNotificationChannel(adhanChannel);
      await androidPlugin.createNotificationChannel(preChannel);
    }
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final notifGranted =
          await androidPlugin?.requestNotificationsPermission() ?? false;
      await androidPlugin?.requestExactAlarmsPermission();
      return notifGranted;
    } else if (Platform.isIOS) {
      final iosPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      return await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

