import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../azkar/domain/entities/dhikr_item.dart';

/// Interactive dhikr counter box for the currently active Azkar item.
class TimedAzkarDhikrBox extends StatelessWidget {
  final DhikrItem active;
  final VoidCallback onTap;

  const TimedAzkarDhikrBox({
    super.key,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return InkWell(
      onTap: () {
        AppHaptics.selection();
        onTap();
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: appColors.accentGold.withValues(alpha: 0.25),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Text(
              active.arabicText,
              textAlign: TextAlign.center,
              style: AppTypography.quranAyah.copyWith(
                fontSize: 16.5.sp,
                color: theme.colorScheme.onSurface,
                height: 1.75,
              ),
            ),
            Gap(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'timed_azkar_tap_hint'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        appColors.emeraldBevelTop,
                        appColors.emeraldBevelBottom,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: appColors.accentGold.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    '${active.remainingCount}x',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.accentGold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
