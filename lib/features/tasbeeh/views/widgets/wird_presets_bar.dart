import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';

/// Hero Quick Presets Bar for applying a unified target count (e.g. 100 to all)
class WirdPresetsBar extends StatelessWidget {
  final ValueChanged<int> onApplyTargetToAll;

  const WirdPresetsBar({
    super.key,
    required this.onApplyTargetToAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 15.sp,
                color: appColors.accentGold,
              ),
              Gap(6.w),
              Text(
                'set_all_targets'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Gap(8.h),
          Row(
            children: [
              _buildPresetPill(context, count: 100, isFeatured: true),
              Gap(8.w),
              _buildPresetPill(context, count: 70),
              Gap(8.w),
              _buildPresetPill(context, count: 33),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetPill(
    BuildContext context, {
    required int count,
    bool isFeatured = false,
  }) {
    final appColors = context.appColors;

    return Expanded(
      child: InkWell(
        onTap: () {
          AppHaptics.selection();
          onApplyTargetToAll(count);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isFeatured
                ? appColors.accentGold.withValues(alpha: 0.16)
                : appColors.badgeBackground,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isFeatured
                  ? appColors.accentGold
                  : appColors.cardBorder,
              width: isFeatured ? 1.2 : 0.8,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isFeatured) ...[
                Icon(
                  Icons.stars_rounded,
                  size: 13.sp,
                  color: appColors.accentGold,
                ),
                Gap(4.w),
              ],
              Text(
                '$count ${"all".tr()}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: isFeatured
                      ? appColors.accentGold
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
