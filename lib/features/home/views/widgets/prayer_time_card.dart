import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/prayer_time_entry.dart';

/// Unified reusable prayer card displaying prayer name, time, icon and status
class PrayerTimeCard extends StatelessWidget {
  final PrayerTimeEntry prayer;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final isNext = prayer.isNext;
    final isPast = prayer.isPast;
    final isAr = context.locale.languageCode == 'ar';
    final prayerName = isAr ? prayer.nameAr : prayer.nameEn;
    final formattedTime = DateFormat(
      'hh:mm a',
      context.locale.languageCode,
    ).format(prayer.time);

    return InkWell(
      onTap: () {
        AppHaptics.selection();
        onTap?.call();
      },
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width ?? 102.w,
        height: height ?? 128.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isNext
              ? theme.colorScheme.surface
              : (isPast
                  ? theme.colorScheme.surface.withValues(alpha: 0.8)
                  : theme.colorScheme.surface),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isNext
                ? appColors.accentGold
                : (isPast
                    ? appColors.cardBorder.withValues(alpha: 0.4)
                    : appColors.cardBorder),
            width: isNext ? 1.2 : 0.8,
          ),
          boxShadow: isNext
              ? [
                  BoxShadow(
                    color: appColors.accentGold.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : appColors.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Icon Container & Prayer Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: isNext
                        ? appColors.accentGold.withValues(alpha: 0.15)
                        : (isPast
                            ? appColors.surfaceSubtle
                            : appColors.badgeBackground),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    isPast ? Icons.check_circle_rounded : prayer.icon,
                    size: 15.sp,
                    color: isNext
                        ? appColors.accentGold
                        : (isPast
                            ? appColors.statusSuccess
                            : theme.colorScheme.primary),
                  ),
                ),
                Flexible(
                  child: Text(
                    prayerName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                      color: isPast
                          ? appColors.textMuted
                          : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Middle: Formatted Time
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.bold,
                color: isNext
                    ? appColors.accentGold
                    : (isPast
                        ? appColors.textMuted
                        : theme.colorScheme.onSurface),
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Bottom: Status Capsule Pill
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 3.5.h),
              decoration: BoxDecoration(
                color: isNext
                    ? appColors.accentGold
                    : (isPast
                        ? appColors.surfaceSubtle
                        : appColors.badgeBackground),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                isNext
                    ? 'prayer_next'.tr()
                    : (isPast ? 'prayer_done'.tr() : 'prayer_upcoming'.tr()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isNext
                      ? Colors.black
                      : (isPast ? appColors.textMuted : appColors.accentGold),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
