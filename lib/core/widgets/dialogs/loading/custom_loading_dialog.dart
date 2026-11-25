import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../utils/extensions.dart';
import '../../../utils/haptics.dart';
import '../base/dialog_frosted_vessel.dart';
import '../base/sanctuary_dialog_badge.dart';
import 'loading_branded_spinner.dart';

/// Celestial Sanctuary Loading Dialog featuring the octagonal mosque astrolabe spinner.
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
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (_) => CustomLoadingDialog(title: title, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return DialogFrostedVessel(
      maxWidth: 300.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoadingBrandedSpinner(),
          Gap(14.h),
          SanctuaryDialogChip(
            label: 'status_loading'.tr(),
            accentColor: appColors.accentGold,
          ),
          Gap(12.h),
          Text(
            title ?? 'loading'.tr(),
            textAlign: TextAlign.center,
            style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          Gap(6.h),
          Text(
            message ?? 'please_wait'.tr(),
            textAlign: TextAlign.center,
            style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
              fontSize: 12.5.sp,
              color: appColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
