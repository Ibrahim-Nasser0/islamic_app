import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../features/home/data/datasources/prayer_calculation_service.dart';
import '../../../features/home/domain/entities/prayer_time_entry.dart';
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
  }) async {
    // 1. Cancel previous alarms
    await _notificationService.cancelAll();

    if (!adhanEnabled && !preAlertEnabled) return;

    final now = DateTime.now();

    // 2. Schedule for 7 days ahead
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

        // A. 5-Minute Pre-Notification
        if (preAlertEnabled) {
          final preTime = prayerTime.subtract(const Duration(minutes: 5));
          if (preTime.isAfter(now)) {
            final preId = 1000 + (dayOffset * 10) + i;
            await _schedulePrePrayerNotification(
              id: preId,
              prayerName: prayerName,
              scheduledDate: preTime,
            );
          }
        }

        // B. Exact Adhan Alarm & Full-Screen Notification
        if (adhanEnabled) {
          if (prayerTime.isAfter(now)) {
            final adhanId = 2000 + (dayOffset * 10) + i;
            await _scheduleExactAdhanNotification(
              id: adhanId,
              prayerKey: prayerKey,
              prayerName: prayerName,
              prayerTime: prayerTime,
            );
          }
        }
      }
    }
  }

  Future<void> _schedulePrePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime scheduledDate,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      NotificationService.preChannelId,
      NotificationService.preChannelName,
      channelDescription: NotificationService.preChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: false,
    );

    await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'اقترب موعد صلاة $prayerName',
      'بقي 5 دقائق لدخول وقت الصلاة • استعد للوضوء والصلاة',
      tzDate,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _scheduleExactAdhanNotification({
    required int id,
    required String prayerKey,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    final tzDate = tz.TZDateTime.from(prayerTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      NotificationService.adhanChannelId,
      NotificationService.adhanChannelName,
      channelDescription: NotificationService.adhanChannelDesc,
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      icon: '@mipmap/ic_launcher',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'stop_adhan',
          'إيقاف الأذان',
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: false,
    );

    final payload = 'adhan:$prayerKey:$prayerName:${prayerTime.toIso8601String()}';

    await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'حان الآن موعد صلاة $prayerName',
      'الله أكبر • حي على الصلاة • حي على الفلاح',
      tzDate,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
}
