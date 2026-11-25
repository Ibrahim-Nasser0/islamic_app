import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/theme/colors.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:islamic_app/core/widgets/custom_button.dart';
import 'package:material_ui/material_ui.dart';
import '../base/dialog_frosted_vessel.dart';
import 'success_badge_illustration.dart';

/// Celestial Sanctuary Success Dialog with emerald bevel CTA and octagonal seal.
class CustomSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const CustomSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
    bool barrierDismissible = false,
  }) {
    AppHaptics.medium();
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (_) => CustomSuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return DialogFrostedVessel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SuccessBadgeIllustration(),
          Gap(14.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          Gap(6.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
              fontSize: 12.5.sp,
              color: appColors.textMuted,
              height: 1.45,
            ),
          ),
          Gap(20.h),
          CustomButton(
            text: buttonText?.tr() ?? 'ok'.tr(),
            height: 46.h,
            borderRadius: 14,
            width: double.infinity,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                appColors.emeraldBevelTop,
                appColors.emeraldBevelBottom,
              ],
            ),
            borderColor: appColors.accentGold.withValues(alpha: 0.48),
            borderWidth: 0.9,
            textColor: AppColors.quranPage,
            onPressed: () {
              AppHaptics.medium();
              Navigator.of(context).pop(true);
              onPressed?.call();
            },
          ).buttonAnimation(),
        ],
      ),
    );
  }
}
