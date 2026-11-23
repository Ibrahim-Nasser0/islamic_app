import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:islamic_app/core/widgets/custom_button.dart';
import 'failure_ui_config.dart';

/// Modal action buttons for Failure Dialog with Apple/Stripe-grade ergonomics
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
            child: InkWell(
              onTap: () {
                AppHaptics.light();
                Navigator.of(context).pop();
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
                  'cancel'.tr(),
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
