import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/animations/button_animation.dart';
import '../../../../core/widgets/custom_button.dart';

/// Empty-state sanctuary card displayed when all Daily Wird items are disabled.
class WirdEmptyCard extends StatelessWidget {
  final VoidCallback onCustomize;

  const WirdEmptyCard({super.key, required this.onCustomize});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: appColors.cardBorder, width: 0.9),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_stories_rounded,
            size: 32.sp,
            color: appColors.accentGold,
          ),
          Gap(10.h),
          Text(
            'tasbeeh_wird_empty_title'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          Gap(6.h),
          Text(
            'tasbeeh_wird_empty_desc'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
          ),
          Gap(14.h),
          CustomButton(
            text: 'customize_wird'.tr(),
            height: 42.h,
            onPressed: () {
              AppHaptics.light();
              onCustomize();
            },
          ).buttonAnimation(),
        ],
      ),
    );
  }
}
