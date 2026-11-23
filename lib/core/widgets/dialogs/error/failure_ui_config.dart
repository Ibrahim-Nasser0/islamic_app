import 'package:material_ui/material_ui.dart';
import 'package:islamic_app/core/theme/colors.dart';
import 'failure_type.dart';

/// Configuration bundle for visual rendering of different failure types
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
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case FailureViewType.network:
        return FailureUIConfig(
          icon: Icons.wifi_off_rounded,
          accentColor: isDark
              ? const Color(0xFF38BDF8)
              : const Color(0xFF0284C7),
          buttonColor: const Color(0xFF0284C7),
          gradientColors: isDark
              ? const [Color(0xFF00F5FF), Color(0xFF0284C7)]
              : const [Color(0xFF0EA5E9), Color(0xFF0369A1)],
          titleKey: 'no_internet_title',
          descKey: 'no_internet_desc',
          statusTagKey: 'status_offline',
        );

      case FailureViewType.server:
        return FailureUIConfig(
          icon: Icons.cloud_off_rounded,
          accentColor: isDark
              ? const Color(0xFF818CF8)
              : const Color(0xFF4F46E5),
          buttonColor: const Color(0xFF4F46E5),
          gradientColors: isDark
              ? const [Color(0xFFA78BFA), Color(0xFF6366F1)]
              : const [Color(0xFF6366F1), Color(0xFF4338CA)],
          titleKey: 'server_error_title',
          descKey: 'server_error_desc',
          statusTagKey: 'status_server_error',
        );

      case FailureViewType.timeout:
        return FailureUIConfig(
          icon: Icons.timer_off_rounded,
          accentColor: isDark
              ? const Color(0xFFFBBF24)
              : const Color(0xFFD97706),
          buttonColor: const Color(0xFFD97706),
          gradientColors: isDark
              ? const [Color(0xFFFDE047), Color(0xFFF59E0B)]
              : const [Color(0xFFF59E0B), Color(0xFFB45309)],
          titleKey: 'timeout_error_title',
          descKey: 'timeout_error_desc',
          statusTagKey: 'status_timeout',
        );

      case FailureViewType.unauthorized:
        return FailureUIConfig(
          icon: Icons.lock_person_rounded,
          accentColor: isDark
              ? const Color(0xFFFCD34D)
              : const Color(0xFFD97706),
          buttonColor: AppColors.primary,
          gradientColors: isDark
              ? const [Color(0xFFFDE68A), Color(0xFFF59E0B)]
              : const [Color(0xFFF59E0B), Color(0xFFB45309)],
          titleKey: 'session_expired_title',
          descKey: 'session_expired_desc',
          statusTagKey: 'status_auth_error',
          isAuthFailure: true,
        );

      case FailureViewType.forbidden:
        return FailureUIConfig(
          icon: Icons.gpp_maybe_rounded,
          accentColor: isDark
              ? const Color(0xFFF87171)
              : const Color(0xFFDC2626),
          buttonColor: const Color(0xFFDC2626),
          gradientColors: isDark
              ? const [Color(0xFFFCA5A5), Color(0xFFEF4444)]
              : const [Color(0xFFEF4444), Color(0xFFB91C1C)],
          titleKey: 'forbidden_error_title',
          descKey: 'forbidden_error_desc',
          statusTagKey: 'status_forbidden',
        );

      case FailureViewType.notFound:
        return FailureUIConfig(
          icon: Icons.search_off_rounded,
          accentColor: isDark
              ? const Color(0xFF2DD4BF)
              : const Color(0xFF0D9488),
          buttonColor: AppColors.secondary,
          gradientColors: isDark
              ? const [Color(0xFF5EEAD4), Color(0xFF0D9488)]
              : const [Color(0xFF14B8A6), Color(0xFF0F766E)],
          titleKey: 'not_found_error_title',
          descKey: 'not_found_error_desc',
          statusTagKey: 'status_not_found',
        );

      case FailureViewType.validation:
        return FailureUIConfig(
          icon: Icons.assignment_late_outlined,
          accentColor: isDark
              ? const Color(0xFFFB923C)
              : const Color(0xFFC2410C),
          buttonColor: const Color(0xFFC2410C),
          gradientColors: isDark
              ? const [Color(0xFFFDBA74), Color(0xFFEA580C)]
              : const [Color(0xFFEA580C), Color(0xFF9A3412)],
          titleKey: 'validation_error_title',
          descKey: 'validation_error_desc',
          statusTagKey: 'status_validation',
        );

      case FailureViewType.generic:
        return FailureUIConfig(
          icon: Icons.error_outline_rounded,
          accentColor: isDark
              ? const Color(0xFFFB7185)
              : const Color(0xFFE11D48),
          buttonColor: const Color(0xFFDC2626),
          gradientColors: isDark
              ? const [Color(0xFFFDA4AF), Color(0xFFE11D48)]
              : const [Color(0xFFF43F5E), Color(0xFFBE123C)],
          titleKey: 'unexpected_error_title',
          descKey: 'unexpected_error_desc',
          statusTagKey: 'status_error',
        );
    }
  }
}
