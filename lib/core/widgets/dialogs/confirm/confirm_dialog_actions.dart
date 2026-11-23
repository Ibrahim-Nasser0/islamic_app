import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';

/// Ergonomic Apple/Stripe-grade dual action buttons for confirmation modals.
/// Features unified 46h dimensions, micro-haptics, text ellipsis protection,
/// and contextual high-contrast chromatic emphasis.
class ConfirmDialogActions extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ConfirmDialogActions({
    super.key,
    required this.cancelText,
    required this.confirmText,
    required this.confirmColor,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // 1. Cancel / Dismiss Action (Apple Frosted Neutral Pill)
        Expanded(
          child: InkWell(
            onTap: () {
              AppHaptics.light();
              onCancel();
            },
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              height: 46.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  width: 1.0,
                ),
              ),
              child: Text(
                cancelText.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.80),
                ),
              ),
            ),
          ).buttonAnimation(),
        ),
        Gap(12.w),

        // 2. Confirm / Commit Action (Chromatic Primary Solid Pill)
        Expanded(
          child: InkWell(
            onTap: () {
              AppHaptics.medium();
              onConfirm();
            },
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              height: 46.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: confirmColor,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: confirmColor.withValues(alpha: 0.32),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                confirmText.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ).buttonAnimation(),
        ),
      ],
    );
  }
}
