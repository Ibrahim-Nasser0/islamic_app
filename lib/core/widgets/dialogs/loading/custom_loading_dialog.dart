import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import '../base/dialog_frosted_vessel.dart';
import 'loading_branded_spinner.dart';

/// Apple-grade frosted glass Loading Dialog featuring the kinetic Mot7km branded spinner
class CustomLoadingDialog extends StatelessWidget {
  final String? title;
  final String? message;

  const CustomLoadingDialog({
    super.key,
    this.title,
    this.message,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? message,
    bool barrierDismissible = false,
  }) {
    AppHaptics.light();
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.50),
      builder: (_) => CustomLoadingDialog(
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final resolvedTitle = title ?? 'loading'.tr();
    final resolvedMessage = message ?? 'please_wait'.tr();

    return DialogFrostedVessel(
      maxWidth: 300.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Kinetic Mot7km Logo with ambient arc
          const LoadingBrandedSpinner(),
          Gap(16.h),

          // 2. Micro Status Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.5.h),
            decoration: BoxDecoration(
              color: primary.withOpacity(isDark ? 0.16 : 0.08),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: primary.withOpacity(isDark ? 0.35 : 0.20),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5.5.r,
                  height: 5.5.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fade(begin: 0.3, end: 1.0, duration: 700.ms),
                Gap(5.w),
                Text(
                  'status_loading'.tr(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: primary,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Gap(12.h),

          // 3. Primary Title
          Text(
            resolvedTitle,
            textAlign: TextAlign.center,
            style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          Gap(6.h),

          // 4. Secondary Description
          Text(
            resolvedMessage,
            textAlign: TextAlign.center,
            style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
              fontSize: 12.5.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.65),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
