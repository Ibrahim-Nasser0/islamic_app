import 'package:material_ui/material_ui.dart';
import 'package:islamic_app/core/theme/colors.dart';
import 'failure_type.dart';

/// Configuration bundle for visual rendering of different failure types.
class FailureUIConfig {
  final IconData icon;
  final Color accentColor;
  final Color buttonColor;
  final List<Color> gradientColors;
  final String titleKey;
  final String descKey;
  final String statusTagKey;
  final bool isAuthFailure;

  const FailureUIConfig({
    required this.icon,
    required this.accentColor,
    required this.buttonColor,
    required this.gradientColors,
    required this.titleKey,
    required this.descKey,
    required this.statusTagKey,
    this.isAuthFailure = false,
  });

  factory FailureUIConfig.fromType(FailureViewType type, ThemeData theme) {
    final cs = theme.colorScheme;
    switch (type) {
      case FailureViewType.network:
        return FailureUIConfig(
          icon: Icons.wifi_off_rounded,
          accentColor: AppColors.info,
          buttonColor: AppColors.info,
          gradientColors: const [AppColors.info, Color(0xFF0369A1)],
          titleKey: 'no_internet_title',
          descKey: 'no_internet_desc',
          statusTagKey: 'status_offline',
        );
      case FailureViewType.server:
        return FailureUIConfig(
          icon: Icons.cloud_off_rounded,
          accentColor: cs.primary,
          buttonColor: cs.primary,
          gradientColors: [cs.primary, AppColors.primaryDark],
          titleKey: 'server_error_title',
          descKey: 'server_error_desc',
          statusTagKey: 'status_server_error',
        );
      case FailureViewType.timeout:
        return const FailureUIConfig(
          icon: Icons.timer_off_rounded,
          accentColor: AppColors.warning,
          buttonColor: AppColors.warning,
          gradientColors: [AppColors.accent, Color(0xFFB45309)],
          titleKey: 'timeout_error_title',
          descKey: 'timeout_error_desc',
          statusTagKey: 'status_timeout',
        );
      case FailureViewType.unauthorized:
        return FailureUIConfig(
          icon: Icons.lock_person_rounded,
          accentColor: AppColors.accent,
          buttonColor: cs.primary,
          gradientColors: [cs.primary, AppColors.primaryDark],
          titleKey: 'session_expired_title',
          descKey: 'session_expired_desc',
          statusTagKey: 'status_auth_error',
          isAuthFailure: true,
        );
      case FailureViewType.forbidden:
        return FailureUIConfig(
          icon: Icons.gpp_maybe_rounded,
          accentColor: cs.error,
          buttonColor: cs.error,
          gradientColors: [cs.error, const Color(0xFFB91C1C)],
          titleKey: 'forbidden_error_title',
          descKey: 'forbidden_error_desc',
          statusTagKey: 'status_forbidden',
        );
      case FailureViewType.notFound:
        return const FailureUIConfig(
          icon: Icons.search_off_rounded,
          accentColor: AppColors.primary,
          buttonColor: AppColors.primary,
          gradientColors: [AppColors.primaryLight, AppColors.primaryDark],
          titleKey: 'not_found_error_title',
          descKey: 'not_found_error_desc',
          statusTagKey: 'status_not_found',
        );
      case FailureViewType.validation:
        return FailureUIConfig(
          icon: Icons.assignment_late_outlined,
          accentColor: AppColors.warning,
          buttonColor: cs.primary,
          gradientColors: const [AppColors.warning, Color(0xFFB45309)],
          titleKey: 'validation_error_title',
          descKey: 'validation_error_desc',
          statusTagKey: 'status_validation',
        );
      case FailureViewType.generic:
        return FailureUIConfig(
          icon: Icons.error_outline_rounded,
          accentColor: cs.error,
          buttonColor: cs.error,
          gradientColors: [cs.error, const Color(0xFFB91C1C)],
          titleKey: 'unexpected_error_title',
          descKey: 'unexpected_error_desc',
          statusTagKey: 'status_error',
        );
    }
  }
}
