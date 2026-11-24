import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/services/native/native_alarm_bridge_service.dart';
import 'package:islamic_app/core/services/native/native_sync_coordinator.dart';
import 'package:islamic_app/core/services/notification/azkar_alarm_scheduler.dart';
import 'package:islamic_app/core/services/notification/prayer_alarm_scheduler.dart';
import 'package:islamic_app/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:islamic_app/features/azkar/domain/entities/azkar_category.dart';
import 'package:islamic_app/features/settings/presentation/models/muadhin_option.dart';

class _FakeAzkarLocalDataSource implements AzkarLocalDataSource {
  final Map<String, int> saved = {};

  @override
  Future<List<AzkarCategory>> getCategories() async => const [];

  @override
  Future<AzkarCategory> getCategoryById(String id) async =>
      throw UnimplementedError();

  @override
  Future<void> resetCategory(String categoryId) async {}

  @override
  Future<void> updateDhikrCount(
    String categoryId,
    String dhikrId,
    int remaining,
  ) async {
    saved['$categoryId:$dhikrId'] = remaining;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.example.islamic_app/native_alarms');
  const legacyNotifChannel =
      MethodChannel('dexterous.com/flutter/local_notifications');
  final List<MethodCall> calls = [];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(legacyNotifChannel, (call) async => null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'consumeDhikrUpdates':
          return [
            {'categoryId': 'morning', 'dhikrId': 'm_1', 'remaining': 0},
            {'categoryId': 'evening', 'dhikrId': 'e_4', 'remaining': 2},
          ];
        case 'consumePendingLaunchRoute':
          return {
            'route': '/azkar-category',
            'args': {'categoryId': 'morning'},
          };
        case 'syncPrayerSchedule':
        case 'syncAzkarSchedule':
        case 'requestNotificationPermission':
          return true;
        case 'checkReliability':
          return {
            'notifications': true,
            'exactAlarms': true,
            'batteryUnrestricted': false,
            'fullScreenIntent': true,
          };
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(legacyNotifChannel, null);
  });

  test('NativeSyncCoordinator merges native lockscreen dhikr updates', () async {
    const bridge = NativeAlarmBridgeService(platformSupportedOverride: true);
    final ds = _FakeAzkarLocalDataSource();
    final coordinator = NativeSyncCoordinator(
      bridge: bridge,
      azkarLocalDataSource: ds,
    );

    final launch = await coordinator.consumeInitialLaunchRoute();

    expect(ds.saved['morning:m_1'], 0);
    expect(ds.saved['evening:e_4'], 2);
    expect(launch?['route'], '/azkar-category');
    expect((launch?['args'] as Map)['categoryId'], 'morning');
    expect(calls.map((c) => c.method), [
      'consumeDhikrUpdates',
      'consumePendingLaunchRoute',
    ]);
  });

  test('PrayerAlarmScheduler sends 7-day native schedule excluding sunrise', () async {
    const bridge = NativeAlarmBridgeService(platformSupportedOverride: true);
    final scheduler = PrayerAlarmScheduler(nativeBridge: bridge);

    await scheduler.schedulePrayerAlarms(
      latitude: 30.0444,
      longitude: 31.2357,
      adhanEnabled: true,
      preAlertEnabled: true,
      lockscreenEnabled: true,
      languageCode: 'ar',
      muadhin: MuadhinOption.defaultList.first,
    );

    final syncCall = calls.singleWhere((c) => c.method == 'syncPrayerSchedule');
    final args = syncCall.arguments as Map;
    final entries = args['entries'] as List;
    expect(args['adhanEnabled'], true);
    expect(args['preAlertEnabled'], true);
    expect(args['lockscreenEnabled'], true);
    expect(entries.length, 35);
    expect(entries.any((e) => (e as Map)['prayerKey'] == 'sunrise'), false);
  });

  test('AzkarAlarmScheduler sends morning and evening items cleanly', () async {
    const bridge = NativeAlarmBridgeService(platformSupportedOverride: true);
    final scheduler = AzkarAlarmScheduler(nativeBridge: bridge);

    await scheduler.scheduleDailyAzkar(enabled: true, languageCode: 'ar');

    final syncCall = calls.singleWhere((c) => c.method == 'syncAzkarSchedule');
    final args = syncCall.arguments as Map;
    expect(args['enabled'], true);
    expect((args['morningItems'] as List), isNotEmpty);
    expect((args['eveningItems'] as List), isNotEmpty);
    expect((args['triggers'] as List), isNotEmpty);
  });

  test('NativeAlarmBridgeService dispatches openNotificationSettings cleanly', () async {
    const bridge = NativeAlarmBridgeService(platformSupportedOverride: true);
    await bridge.openNotificationSettings();
    await bridge.openExactAlarmSettings();
    await bridge.openFullScreenIntentSettings();
    await bridge.openBatterySettings();
    final granted = await bridge.requestNotificationPermission();

    expect(granted, true);
    expect(calls.map((c) => c.method), [
      'openNotificationSettings',
      'openExactAlarmSettings',
      'openFullScreenIntentSettings',
      'openBatterySettings',
      'requestNotificationPermission',
    ]);
  });
}
