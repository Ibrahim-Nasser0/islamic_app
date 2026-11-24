import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../features/settings/data/datasources/settings_local_data_source.dart';
import '../notification/azkar_alarm_scheduler.dart';
import '../notification/notification_service.dart';
import '../notification/prayer_alarm_scheduler.dart';
import 'native_alarm_bridge_service.dart';
import 'permission_readiness_state.dart';

/// Cubit managing runtime permission checks and guided remediation for Adhan & Prayer Times.
class PermissionReadinessCubit extends Cubit<PermissionReadinessState> {
  final NativeAlarmBridgeService _bridge;
  final NotificationService _notificationService;
  final PrayerAlarmScheduler _prayerScheduler;
  final AzkarAlarmScheduler _azkarScheduler;
  final SettingsLocalDataSource _settingsDs;

  PermissionReadinessCubit({
    required NativeAlarmBridgeService bridge,
    required NotificationService notificationService,
    required PrayerAlarmScheduler prayerScheduler,
    required AzkarAlarmScheduler azkarScheduler,
    required SettingsLocalDataSource settingsDs,
  })  : _bridge = bridge,
        _notificationService = notificationService,
        _prayerScheduler = prayerScheduler,
        _azkarScheduler = azkarScheduler,
        _settingsDs = settingsDs,
        super(const PermissionReadinessState());

  Future<void> refresh() async {
    final rel = await _bridge.checkReliability();
    var locGranted = false;
    try {
      final perm = await Geolocator.checkPermission();
      locGranted = perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse;
    } catch (_) {
      locGranted = false;
    }
    if (isClosed) return;
    emit(state.copyWith(
      notificationsGranted: rel['notifications'] ?? false,
      exactAlarmsGranted: rel['exactAlarms'] ?? true,
      fullScreenIntentGranted: rel['fullScreenIntent'] ?? true,
      batteryUnrestricted: rel['batteryUnrestricted'] ?? true,
      locationGranted: locGranted,
    ));
  }

  Future<void> requestNotifications() async {
    if (isClosed) return;
    emit(state.copyWith(isBusy: true));
    final granted = await _notificationService.requestPermissions();
    if (!granted) {
      final rel = await _bridge.checkReliability();
      if (rel['notifications'] != true) {
        await _bridge.openNotificationSettings();
      }
    }
    await _rescheduleAlarms();
    await refresh();
    if (!isClosed) emit(state.copyWith(isBusy: false));
  }

  Future<void> requestLocation() async {
    if (isClosed) return;
    emit(state.copyWith(isBusy: true));
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
    } catch (_) {}
    await _rescheduleAlarms();
    await refresh();
    if (!isClosed) emit(state.copyWith(isBusy: false));
  }

  Future<void> fixExactAlarms() async {
    await _bridge.openExactAlarmSettings();
    await refresh();
  }

  Future<void> fixBatteryOptimization() async {
    await _bridge.openBatterySettings();
    await refresh();
  }

  Future<void> requestEssentialBatch() async {
    if (isClosed) return;
    emit(state.copyWith(isBusy: true));
    try {
      await _notificationService.requestPermissions();
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      await _rescheduleAlarms();
    } catch (_) {}
    await refresh();
    if (!isClosed) emit(state.copyWith(isBusy: false));
  }

  Future<void> _rescheduleAlarms() async {
    try {
      final loc = _settingsDs.getLocation();
      await _prayerScheduler.schedulePrayerAlarms(
        latitude: loc.lat,
        longitude: loc.lng,
        adhanEnabled:
            _settingsDs.getPrayerNotification() && _settingsDs.getAthanSound(),
        preAlertEnabled: _settingsDs.getPrayerNotification() &&
            _settingsDs.getPrePrayerNotification(),
      );
      await _azkarScheduler.scheduleDailyAzkar(
        enabled: _settingsDs.getAzkarNotification(),
      );
    } catch (_) {}
  }
}
