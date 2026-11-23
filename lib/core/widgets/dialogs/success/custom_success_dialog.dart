import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:islamic_app/core/widgets/custom_button.dart';
import '../base/dialog_frosted_vessel.dart';
import 'success_badge_illustration.dart';

/// Apple-grade frosted glass Success Dialog with cohesive branding and emerald glow
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
      barrierColor: Colors.black.withOpacity(0.55),
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
    const emeraldColor = Color(0xFF10B981);

    return DialogFrostedVessel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Layered animated hero illustration
          const SuccessBadgeIllustration(),
          Gap(14.h),

          // 2. Localized Title
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
              color: theme.colorScheme.onSurface.withOpacity(0.65),
              height: 1.4,
            ),
          ),
          Gap(22.h),

          // 4. Action Button
          CustomButton(
            text: buttonText?.tr() ?? 'ok'.tr(),
            height: 46.h,
            borderRadius: 14,
            width: double.infinity,
            color: emeraldColor,
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
