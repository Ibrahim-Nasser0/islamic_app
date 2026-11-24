import '../../../features/azkar/data/datasources/azkar_evening_data.dart';
import '../../../features/azkar/data/datasources/azkar_morning_data.dart';
import '../../../features/azkar/domain/entities/dhikr_item.dart';
import '../../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../di/injection_container.dart' as di;
import '../native/native_alarm_bridge_service.dart';
import 'notification_service.dart';

class AzkarAlarmScheduler {
  final NotificationService _notificationService = NotificationService();
  final NativeAlarmBridgeService _nativeBridge;

  AzkarAlarmScheduler({NativeAlarmBridgeService? nativeBridge})
      : _nativeBridge = nativeBridge ?? NativeAlarmBridgeService();

  static const int morningHour = 7;
  static const int morningMinute = 0;
  static const int eveningHour = 17;
  static const int eveningMinute = 0;

  Future<void> scheduleDailyAzkar({
    required bool enabled,
    String? languageCode,
  }) async {
    for (int id = 3000; id <= 3030; id++) {
      await _notificationService.cancel(id);
    }

    if (!_nativeBridge.isSupportedPlatform) return;
    if (!enabled) {
      await _nativeBridge.cancelAllAzkarAlarms();
      return;
    }

    final lang = languageCode ?? _resolveLanguageCode();
    final now = DateTime.now();
    final List<Map<String, dynamic>> triggers = [];

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final base = now.add(Duration(days: dayOffset));
      final morningTime = DateTime(
        base.year,
        base.month,
        base.day,
        morningHour,
        morningMinute,
      );
      if (morningTime.isAfter(now)) {
        triggers.add({
          'id': 3000 + (dayOffset * 2),
          'categoryId': 'morning',
          'atMillis': morningTime.millisecondsSinceEpoch,
        });
      }

      final eveningTime = DateTime(
        base.year,
        base.month,
        base.day,
        eveningHour,
        eveningMinute,
      );
      if (eveningTime.isAfter(now)) {
        triggers.add({
          'id': 3000 + (dayOffset * 2) + 1,
          'categoryId': 'evening',
          'atMillis': eveningTime.millisecondsSinceEpoch,
        });
      }
    }

    await _nativeBridge.syncAzkarSchedule({
      'enabled': enabled,
      'languageCode': lang,
      'triggers': triggers,
      'morningItems': AzkarMorningData.items.map(_serializeDhikr).toList(),
      'eveningItems': AzkarEveningData.items.map(_serializeDhikr).toList(),
    });
  }

  Future<void> triggerPreviewAzkar({
    String categoryId = 'morning',
    String? languageCode,
  }) async {
    final lang = languageCode ?? _resolveLanguageCode();
    final items = categoryId == 'evening'
        ? AzkarEveningData.items
        : AzkarMorningData.items;
    await _nativeBridge.previewNativeAzkar({
      'categoryId': categoryId,
      'languageCode': lang,
      'items': items.map(_serializeDhikr).toList(),
    });
  }

  Map<String, dynamic> _serializeDhikr(DhikrItem item) => {
        'id': item.id,
        'arabicText': item.arabicText,
        'targetCount': item.targetCount,
        'fadl': item.fadl,
        'reference': item.reference,
      };

  String _resolveLanguageCode() {
    try {
      return di.sl<SettingsLocalDataSource>().getLanguageCode();
    } catch (_) {
      return 'ar';
    }
  }
}
