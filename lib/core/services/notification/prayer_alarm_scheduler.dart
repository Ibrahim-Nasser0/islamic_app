import '../../../features/home/data/datasources/prayer_calculation_service.dart';
import '../../../features/home/domain/entities/prayer_time_entry.dart';
import '../../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../../features/settings/presentation/models/muadhin_option.dart';
import '../../di/injection_container.dart' as di;
import '../native/native_alarm_bridge_service.dart';
import 'notification_service.dart';

class PrayerAlarmScheduler {
  final NotificationService _notificationService = NotificationService();
  final PrayerCalculationService _calculationService;
  final NativeAlarmBridgeService _nativeBridge;

  PrayerAlarmScheduler({
    PrayerCalculationService? calculationService,
    NativeAlarmBridgeService? nativeBridge,
  })  : _calculationService = calculationService ?? PrayerCalculationService(),
        _nativeBridge = nativeBridge ?? NativeAlarmBridgeService();

  Future<void> schedulePrayerAlarms({
    required double latitude,
    required double longitude,
    required bool adhanEnabled,
    required bool preAlertEnabled,
    bool? lockscreenEnabled,
    String? languageCode,
    MuadhinOption? muadhin,
  }) async {
    await _cancelLegacyPrayerNotifications();
    if (!_nativeBridge.isSupportedPlatform) return;

    if (!adhanEnabled && !preAlertEnabled) {
      await _nativeBridge.cancelAllPrayerAlarms();
      return;
    }

    final ds = _trySettingsDs();
    final chosenMuadhin = muadhin ?? _resolveMuadhin(ds);
    final useLockscreen = lockscreenEnabled ?? (ds?.getAdhanLockscreen() ?? true);
    final lang = languageCode ?? (ds?.getLanguageCode() ?? 'ar');
    final now = DateTime.now();

    final List<Map<String, dynamic>> entries = [];
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
        final isFajr = prayer.type == PrayerType.fajr;
        final preTime = prayer.time.subtract(const Duration(minutes: 5));

        entries.add({
          'adhanId': 2000 + (dayOffset * 10) + i,
          'preId': 1000 + (dayOffset * 10) + i,
          'prayerKey': prayer.type.name,
          'titleAr': prayer.nameAr,
          'titleEn': prayer.nameEn,
          'adhanAtMillis': prayer.time.millisecondsSinceEpoch,
          'preAtMillis': preTime.millisecondsSinceEpoch,
          'rawSound': chosenMuadhin.getRawSound(isFajr: isFajr),
          'iosSound': chosenMuadhin.getIosCafSound(isFajr: isFajr),
          'channelId': chosenMuadhin.getChannelId(isFajr: isFajr),
        });
      }
    }

    await _nativeBridge.syncPrayerSchedule({
      'adhanEnabled': adhanEnabled,
      'preAlertEnabled': preAlertEnabled,
      'lockscreenEnabled': useLockscreen,
      'languageCode': lang,
      'muezzinId': chosenMuadhin.id,
      'muezzinNameAr': chosenMuadhin.nameAr,
      'muezzinNameEn': chosenMuadhin.nameEn,
      'muezzinLocation': chosenMuadhin.location,
      'entries': entries,
    });
  }

  Future<void> triggerPreviewAdhan({
    MuadhinOption? muadhin,
    String? languageCode,
  }) async {
    final ds = _trySettingsDs();
    final chosen = muadhin ?? _resolveMuadhin(ds);
    final lang = languageCode ?? (ds?.getLanguageCode() ?? 'ar');
    await _nativeBridge.previewNativeAdhan({
      'prayerKey': 'fajr',
      'titleAr': 'الفجر',
      'titleEn': 'Fajr',
      'prayerTimeMillis': DateTime.now().millisecondsSinceEpoch,
      'rawSound': chosen.getRawSound(isFajr: true),
      'iosSound': chosen.getIosCafSound(isFajr: true),
      'muezzinNameAr': chosen.nameAr,
      'muezzinNameEn': chosen.nameEn,
      'muezzinLocation': chosen.location,
      'languageCode': lang,
    });
  }

  Future<void> _cancelLegacyPrayerNotifications() async {
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      for (int i = 0; i < 5; i++) {
        await _notificationService.cancel(1000 + (dayOffset * 10) + i);
        await _notificationService.cancel(2000 + (dayOffset * 10) + i);
      }
    }
  }

  SettingsLocalDataSource? _trySettingsDs() {
    try {
      return di.sl<SettingsLocalDataSource>();
    } catch (_) {
      return null;
    }
  }

  MuadhinOption _resolveMuadhin(SettingsLocalDataSource? ds) {
    final saved = ds?.getMuadhinVoice();
    return MuadhinOption.defaultList.firstWhere(
      (m) => m.id == saved,
      orElse: () => MuadhinOption.defaultList.first,
    );
  }
}
