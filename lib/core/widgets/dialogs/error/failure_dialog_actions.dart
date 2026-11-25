import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:islamic_app/core/widgets/custom_button.dart';
import 'package:material_ui/material_ui.dart';
import 'failure_ui_config.dart';

/// Modal action buttons for Celestial Sanctuary Failure Dialog.
class FailureDialogActions extends StatelessWidget {
  final FailureUIConfig config;
  final VoidCallback? onRetry;
  final String? retryText;

  const FailureDialogActions({
    super.key,
    required this.config,
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    if (config.isAuthFailure) {
      return CustomButton(
        text: 'login_again'.tr(),
        icon: Icons.login_rounded,
        height: 46.h,
        borderRadius: 14,
        width: double.infinity,
        color: config.buttonColor,
        onPressed: () {
          AppHaptics.medium();
          Navigator.of(context).pop();
          AppRouter.navigateAndRemoveUntil(context, Routes.login);
        },
      ).buttonAnimation();
    }

    if (onRetry != null) {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'cancel'.tr(),
              height: 46.h,
              borderRadius: 14,
              color: appColors.surfaceSubtle,
              borderColor: appColors.cardBorder,
              borderWidth: 0.9,
              textColor: theme.colorScheme.onSurface,
              onPressed: () {
                AppHaptics.light();
                Navigator.of(context).pop();
              },
            ).buttonAnimation(),
          ),
          Gap(12.w),
          Expanded(
            child: CustomButton(
              text: retryText ?? 'retry'.tr(),
              icon: Icons.refresh_rounded,
              height: 46.h,
              borderRadius: 14,
              width: double.infinity,
              color: config.buttonColor,
              onPressed: () {
                AppHaptics.medium();
                Navigator.of(context).pop();
                onRetry!();
              },
            ).buttonAnimation(),
          ),
        ],
      );
    }

    return CustomButton(
      text: 'ok'.tr(),
      height: 46.h,
      borderRadius: 14,
      width: double.infinity,
      color: config.buttonColor,
      onPressed: () {
        AppHaptics.medium();
        Navigator.of(context).pop();
      },
    ).buttonAnimation();
  }
}
