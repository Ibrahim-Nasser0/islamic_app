import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../features/home/data/datasources/prayer_calculation_service.dart';
import '../../../features/home/domain/entities/prayer_time_entry.dart';
import '../../../features/settings/presentation/models/muadhin_option.dart';
import '../../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../di/injection_container.dart' as di;
import 'notification_service.dart';

class PrayerAlarmScheduler {
  final NotificationService _notificationService = NotificationService();
  final PrayerCalculationService _calculationService;

  PrayerAlarmScheduler({PrayerCalculationService? calculationService})
      : _calculationService =
            calculationService ?? PrayerCalculationService();

  Future<void> schedulePrayerAlarms({
    required double latitude,
    required double longitude,
    required bool adhanEnabled,
    required bool preAlertEnabled,
    MuadhinOption? muadhin,
  }) async {
    await _notificationService.cancelAll();
    if (!adhanEnabled && !preAlertEnabled) return;

    final chosenMuadhin = muadhin ?? _resolveMuadhin();
    final now = DateTime.now();
    final canExact = await _notificationService.canScheduleExactAlarms();
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final schedule = _calculationService.calculateSchedule(
        latitude: latitude,
        longitude: longitude,
        locationNameAr: 'القاهرة',
        locationNameEn: 'Cairo',
        targetDate: targetDate,
      );

      final adhanPrayers = schedule.prayers
          .where((p) => p.type != PrayerType.sunrise)
          .toList();

      for (int i = 0; i < adhanPrayers.length; i++) {
        final prayer = adhanPrayers[i];
        final prayerKey = prayer.type.name;
        final prayerName = prayer.nameAr;
        final prayerTime = prayer.time;

        if (preAlertEnabled && prayerTime.subtract(const Duration(minutes: 5)).isAfter(now)) {
          await _schedulePrePrayer(
            id: 1000 + (dayOffset * 10) + i,
            prayerKey: prayerKey,
            prayerName: prayerName,
            date: prayerTime.subtract(const Duration(minutes: 5)),
            mode: scheduleMode,
          );
        }

        if (adhanEnabled && prayerTime.isAfter(now)) {
          await _scheduleExactAdhan(
            id: 2000 + (dayOffset * 10) + i,
            prayerKey: prayerKey,
            prayerName: prayerName,
            time: prayerTime,
            muadhin: chosenMuadhin,
            mode: scheduleMode,
          );
        }
      }
    }
  }

  MuadhinOption _resolveMuadhin() {
    try {
      final ds = di.sl<SettingsLocalDataSource>();
      return MuadhinOption.defaultList.firstWhere(
        (m) => m.id == ds.getMuadhinVoice(),
        orElse: () => MuadhinOption.defaultList.first,
      );
    } catch (_) {
      return MuadhinOption.defaultList.first;
    }
  }

  Future<void> _schedulePrePrayer({
    required int id,
    required String prayerKey,
    required String prayerName,
    required DateTime date,
    required AndroidScheduleMode mode,
  }) async {
    final tzDate = tz.TZDateTime.from(date, tz.local);
    const android = AndroidNotificationDetails(
      NotificationService.preChannelId,
      NotificationService.preChannelName,
      channelDescription: NotificationService.preChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const ios = DarwinNotificationDetails(presentAlert: true, presentSound: true);

    try {
      await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'اقترب موعد صلاة $prayerName',
        'بقي 5 دقائق لدخول وقت الصلاة • استعد للوضوء والصلاة',
        tzDate,
        const NotificationDetails(android: android, iOS: ios),
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'pre:$prayerKey:$prayerName',
      );
    } catch (_) {
      await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'اقترب موعد صلاة $prayerName',
        'بقي 5 دقائق لدخول وقت الصلاة • استعد للوضوء والصلاة',
        tzDate,
        const NotificationDetails(android: android, iOS: ios),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'pre:$prayerKey:$prayerName',
      );
    }
  }

  Future<void> _scheduleExactAdhan({
    required int id,
    required String prayerKey,
    required String prayerName,
    required DateTime time,
    required MuadhinOption muadhin,
    required AndroidScheduleMode mode,
  }) async {
    final tzDate = tz.TZDateTime.from(time, tz.local);
    final isFajr = prayerKey.toLowerCase() == 'fajr';
    final sound = RawResourceAndroidNotificationSound(muadhin.getRawSound(isFajr: isFajr));

    final android = AndroidNotificationDetails(
      muadhin.getChannelId(isFajr: isFajr),
      'أذان $prayerName',
      channelDescription: 'تنبيه الأذان مع تشغيل الصوت تلقائياً',
      importance: Importance.max,
      priority: Priority.max,
      sound: sound,
      playSound: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      icon: '@mipmap/ic_launcher',
      actions: const <AndroidNotificationAction>[
        AndroidNotificationAction('open_adhan', 'عرض الأذان والدعاء', showsUserInterface: true),
        AndroidNotificationAction('stop_adhan', 'إيقاف الأذان', cancelNotification: true),
      ],
    );
    const ios = DarwinNotificationDetails(presentAlert: true, presentSound: true);
    final payload = 'adhan:$prayerKey:$prayerName:${time.toIso8601String()}:$id';
    final details = NotificationDetails(android: android, iOS: ios);

    try {
      await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        id, 'حان الآن موعد صلاة $prayerName', 'الله أكبر • حي على الصلاة • حي على الفلاح',
        tzDate, details, androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (_) {
      await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        id, 'حان الآن موعد صلاة $prayerName', 'الله أكبر • حي على الصلاة • حي على الفلاح',
        tzDate, details, androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
  }
}
