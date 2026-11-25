import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/theme/colors.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:islamic_app/core/widgets/custom_button.dart';
import 'package:material_ui/material_ui.dart';

/// Celestial Sanctuary dual action buttons for confirmation dialogs.
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
    final appColors = context.appColors;
    final isDanger = confirmColor == theme.colorScheme.error ||
        confirmColor == const Color(0xFFEF4444) ||
        confirmColor == const Color(0xFFDC2626);

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: cancelText.tr(),
            height: 46.h,
            borderRadius: 14,
            fontSize: 13.sp,
            color: appColors.surfaceSubtle,
            borderColor: appColors.cardBorder,
            borderWidth: 0.9,
            textColor: theme.colorScheme.onSurface,
            onPressed: () {
              AppHaptics.light();
              onCancel();
            },
          ).buttonAnimation(),
        ),
        Gap(12.w),
        Expanded(
          child: CustomButton(
            text: confirmText.tr(),
            height: 46.h,
            borderRadius: 14,
            fontSize: 13.sp,
            color: isDanger ? confirmColor : null,
            gradient: isDanger
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      appColors.emeraldBevelTop,
                      appColors.emeraldBevelBottom,
                    ],
                  ),
            borderColor: isDanger
                ? null
                : appColors.accentGold.withValues(alpha: 0.48),
            borderWidth: isDanger ? 0 : 0.9,
            textColor: AppColors.quranPage,
            onPressed: () {
              AppHaptics.medium();
              onConfirm();
            },
          ).buttonAnimation(),
        ),
      ],
    );
  }
}
