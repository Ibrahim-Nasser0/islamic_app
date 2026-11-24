import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

/// Stateless platform-channel bridge communicating with Android/iOS native alarm engines.
class NativeAlarmBridgeService {
  static const MethodChannel _channel =
      MethodChannel('com.example.islamic_app/native_alarms');

  final bool? _platformSupportedOverride;

  const NativeAlarmBridgeService({bool? platformSupportedOverride})
      : _platformSupportedOverride = platformSupportedOverride;

  bool get isSupportedPlatform =>
      _platformSupportedOverride ?? (Platform.isAndroid || Platform.isIOS);

  void setNativeRouteListener(
    Future<void> Function(String route, Map<String, dynamic>? args) onRoute,
  ) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openRoute') {
        final raw = call.arguments;
        if (raw is Map) {
          final route = raw['route'] as String?;
          final argsRaw = raw['args'];
          final args = argsRaw is Map
              ? Map<String, dynamic>.from(argsRaw)
              : null;
          if (route != null && route.isNotEmpty) {
            await onRoute(route, args);
          }
        }
      }
    });
  }

  Future<bool> syncPrayerSchedule(Map<String, dynamic> payload) async {
    if (!isSupportedPlatform) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('syncPrayerSchedule', payload);
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> syncAzkarSchedule(Map<String, dynamic> payload) async {
    if (!isSupportedPlatform) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('syncAzkarSchedule', payload);
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelAllPrayerAlarms() async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('cancelPrayerAlarms');
    } catch (_) {}
  }

  Future<void> cancelAllAzkarAlarms() async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('cancelAzkarAlarms');
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> consumePendingLaunchRoute() async {
    if (!isSupportedPlatform) return null;
    try {
      final raw = await _channel.invokeMethod<dynamic>('consumePendingLaunchRoute');
      if (raw is Map && raw['route'] is String) {
        final argsRaw = raw['args'];
        return {
          'route': raw['route'] as String,
          'args': argsRaw is Map ? Map<String, dynamic>.from(argsRaw) : null,
        };
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> consumeNativeDhikrUpdates() async {
    if (!isSupportedPlatform) return const [];
    try {
      final raw = await _channel.invokeMethod<dynamic>('consumeDhikrUpdates');
      if (raw is List) {
        return raw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, bool>> checkReliability() async {
    if (!isSupportedPlatform) {
      return const {
        'notifications': true,
        'exactAlarms': true,
        'batteryUnrestricted': true,
        'fullScreenIntent': true,
      };
    }
    try {
      final raw = await _channel.invokeMethod<dynamic>('checkReliability');
      if (raw is Map) {
        return raw.map((k, v) => MapEntry(k.toString(), v == true));
      }
    } catch (_) {}
    return const {
      'notifications': false,
      'exactAlarms': false,
      'batteryUnrestricted': false,
      'fullScreenIntent': false,
    };
  }

  Future<void> openBatterySettings() => _invokeVoid('openBatterySettings');
  Future<void> openExactAlarmSettings() => _invokeVoid('openExactAlarmSettings');
  Future<void> openFullScreenIntentSettings() =>
      _invokeVoid('openFullScreenIntentSettings');

  Future<bool> requestIosPermissions() async {
    if (!Platform.isIOS) return true;
    try {
      return await _channel.invokeMethod<bool>('requestPermissions') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> previewNativeAdhan(Map<String, dynamic> payload) async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('previewNativeAdhan', payload);
    } catch (_) {}
  }

  Future<void> previewNativeAzkar(Map<String, dynamic> payload) async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('previewNativeAzkar', payload);
    } catch (_) {}
  }

  Future<void> _invokeVoid(String method) async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>(method);
    } catch (_) {}
  }
}
