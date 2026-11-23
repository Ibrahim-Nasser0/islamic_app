import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';

/// Hint container recommending phone motion to calibrate compass sensor
class QiblaCalibrationHint extends StatelessWidget {
  final bool hasCompass;

  const QiblaCalibrationHint({super.key, required this.hasCompass});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: appColors.cardBorder.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: appColors.badgeBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              hasCompass
                  ? Icons.screen_rotation_rounded
                  : Icons.info_outline_rounded,
              size: 18.sp,
              color: appColors.accentGold,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Text(
              hasCompass
                  ? 'calibrate_compass'.tr()
                  : 'no_compass_sensor'.tr(),
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
                color: appColors.textMuted,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
