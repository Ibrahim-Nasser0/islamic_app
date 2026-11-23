import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import '../base/dialog_frosted_vessel.dart';
import 'confirm_badge_illustration.dart';
import 'confirm_dialog_actions.dart';

/// Apple-grade frosted glass Confirmation Dialog with living squircle badge
/// and ergonomic dual-action buttons.
class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color iconColor;
  final Color? confirmButtonColor;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'ok',
    this.cancelText = 'cancel',
    this.icon = Icons.warning_amber_rounded,
    this.iconColor = const Color(0xFFF59E0B),
    this.confirmButtonColor,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'ok',
    String cancelText = 'cancel',
    IconData icon = Icons.warning_amber_rounded,
    Color iconColor = const Color(0xFFF59E0B),
    Color? confirmButtonColor,
  }) {
    AppHaptics.medium();
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => CustomConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        confirmButtonColor: confirmButtonColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveConfirmColor =
        confirmButtonColor ?? _resolveConfirmColor(iconColor, theme);

    return DialogFrostedVessel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Layered Apple Squircle Hero Badge
          ConfirmBadgeIllustration(
            icon: icon,
            iconColor: iconColor,
          ),
          Gap(16.h),

          // 2. Title with crisp typography
          Text(
            title,
            textAlign: TextAlign.center,
            style: (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          Gap(6.h),

          // 3. User-friendly Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
              fontSize: 12.5.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
          Gap(22.h),

          // 4. Ergonomic Dual Action Buttons
          ConfirmDialogActions(
            cancelText: cancelText,
            confirmText: confirmText,
            confirmColor: effectiveConfirmColor,
            onCancel: () => Navigator.pop(context, false),
            onConfirm: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  static Color _resolveConfirmColor(Color iconColor, ThemeData theme) {
    if (iconColor == Colors.red ||
        iconColor == const Color(0xFFEF4444) ||
        iconColor == const Color(0xFFDC2626)) {
      return const Color(0xFFEF4444);
    }
    if (iconColor == const Color(0xFFF59E0B) ||
        iconColor == const Color(0xFFD97706) ||
        iconColor == Colors.amber) {
      return const Color(0xFFD97706);
    }
    if (iconColor == const Color(0xFF10B981) ||
        iconColor == const Color(0xFF059669)) {
      return const Color(0xFF10B981);
    }
    return theme.colorScheme.primary;
  }
}
