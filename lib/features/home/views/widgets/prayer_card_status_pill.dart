import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/prayer_time_entry.dart';

/// Refined bottom status capsule for next, past, and upcoming prayer states.
class PrayerCardStatusPill extends StatelessWidget {
  final PrayerEntryStatus status;

  const PrayerCardStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isNext = status == PrayerEntryStatus.next;
    final isPast = status == PrayerEntryStatus.past;

    final bgColor = isNext
        ? AppColors.accentLight.withValues(alpha: 0.16)
        : (isPast
            ? appColors.statusSuccess.withValues(alpha: 0.10)
            : appColors.surfaceSubtle);
    final borderColor = isNext
        ? AppColors.accentLight.withValues(alpha: 0.45)
        : (isPast
            ? appColors.statusSuccess.withValues(alpha: 0.28)
            : appColors.cardBorder);
    final fgColor = isNext
        ? AppColors.accentLight
        : (isPast ? appColors.statusSuccess : appColors.textMuted);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 0.75),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNext) ...[
            RubElHizbMark(size: 7.w, color: fgColor),
            Gap(3.w),
          ] else if (isPast) ...[
            Icon(Icons.check_rounded, size: 10.sp, color: fgColor),
            Gap(2.w),
          ],
          Flexible(
            child: Text(
              isNext
                  ? 'prayer_next'.tr()
                  : (isPast ? 'prayer_done'.tr() : 'prayer_upcoming'.tr()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                color: fgColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
