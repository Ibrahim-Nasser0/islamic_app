import 'package:flutter/widgets.dart';
import '../../routes/app_router.dart';
import '../../routes/routes.dart';
import '../../../features/azkar/data/datasources/azkar_local_data_source.dart';
import 'native_alarm_bridge_service.dart';

/// Synchronizes native lockscreen Azkar updates and deep-link navigation with Flutter.
class NativeSyncCoordinator {
  final NativeAlarmBridgeService _bridge;
  final AzkarLocalDataSource _azkarLocalDataSource;

  NativeSyncCoordinator({
    required NativeAlarmBridgeService bridge,
    required AzkarLocalDataSource azkarLocalDataSource,
  })  : _bridge = bridge,
        _azkarLocalDataSource = azkarLocalDataSource;

  void bindForegroundRouteHandler() {
    _bridge.setNativeRouteListener((route, args) async {
      await syncPendingDhikrUpdates();
      navigateToNativeRoute(route, args);
    });
  }

  Future<void> syncPendingDhikrUpdates() async {
    final updates = await _bridge.consumeNativeDhikrUpdates();
    for (final entry in updates) {
      final categoryId = entry['categoryId'] as String?;
      final dhikrId = entry['dhikrId'] as String?;
      final remaining = entry['remaining'] as int?;
      if (categoryId != null && dhikrId != null && remaining != null) {
        await _azkarLocalDataSource.updateDhikrCount(
          categoryId,
          dhikrId,
          remaining,
        );
      }
    }
  }

  Future<Map<String, dynamic>?> consumeInitialLaunchRoute() async {
    await syncPendingDhikrUpdates();
    return _bridge.consumePendingLaunchRoute();
  }

  void navigateToNativeRoute(String route, Map<String, dynamic>? args) {
    final nav = AppRouter.navigatorKey.currentState;
    if (nav == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route == Routes.home) {
        nav.popUntil((r) => r.isFirst);
      } else {
        nav.pushNamed(route, arguments: args);
      }
    });
  }
}
