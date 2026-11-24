import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

class AzkarAlarmScheduler {
  final NotificationService _notificationService = NotificationService();

  static const int morningHour = 7;
  static const int morningMinute = 0;
  static const int eveningHour = 17;
  static const int eveningMinute = 0;

  Future<void> scheduleDailyAzkar({required bool enabled}) async {
    // 1. Cancel previous azkar alarms (IDs 3000-3030)
    for (int id = 3000; id <= 3030; id++) {
      await _notificationService.cancel(id);
    }

    if (!enabled) return;

    final now = DateTime.now();
    final canExact = await _notificationService.canScheduleExactAlarms();
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    // 2. Schedule for 7 days ahead
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final baseDate = now.add(Duration(days: dayOffset));

      // A. Morning Azkar (07:00 AM)
      final morningTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        morningHour,
        morningMinute,
      );
      if (morningTime.isAfter(now)) {
        final id = 3000 + (dayOffset * 2);
        await _scheduleAzkarEntry(
          id: id,
          title: 'أذكار الصباح ☀️',
          body: 'أصبحنا وأصبح الملك لله • ابدأ يومك بحفظ الله وذكره',
          scheduledDate: morningTime,
          categoryId: 'morning',
          scheduleMode: scheduleMode,
        );
      }

      // B. Evening Azkar (05:00 PM)
      final eveningTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        eveningHour,
        eveningMinute,
      );
      if (eveningTime.isAfter(now)) {
        final id = 3000 + (dayOffset * 2) + 1;
        await _scheduleAzkarEntry(
          id: id,
          title: 'أذكار المساء 🌙',
          body: 'أمسينا وأمسى الملك لله • حصن نفسك وأهلك بذكر الله',
          scheduledDate: eveningTime,
          categoryId: 'evening',
          scheduleMode: scheduleMode,
        );
      }
    }
  }

  Future<void> _scheduleAzkarEntry({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String categoryId,
    required AndroidScheduleMode scheduleMode,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      NotificationService.azkarChannelId,
      NotificationService.azkarChannelName,
      channelDescription: NotificationService.azkarChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      category: AndroidNotificationCategory.reminder,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'open_azkar',
          'قراءة الأذكار',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: false,
    );

    try {
      await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        const NotificationDetails(android: androidDetails, iOS: iosDetails),
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'azkar:$categoryId',
      );
    } catch (_) {
      // Fallback for devices restricting exact alarms
      if (Platform.isAndroid) {
        await _notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDate,
          const NotificationDetails(android: androidDetails, iOS: iosDetails),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'azkar:$categoryId',
        );
      }
    }
  }
}
