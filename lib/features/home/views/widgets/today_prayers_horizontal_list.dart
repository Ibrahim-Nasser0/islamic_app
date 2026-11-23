import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/prayer_time_entry.dart';

/// Horizontal Row List displaying all prayers of the day with accurate status
class TodayPrayersHorizontalList extends StatelessWidget {
  final List<PrayerTimeEntry> prayers;
  final ValueChanged<int>? onPrayerTap;

  const TodayPrayersHorizontalList({
    super.key,
    required this.prayers,
    this.onPrayerTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'today_prayers'.tr(),
              style: AppTypography.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              'prayers_count'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: appColors.accentGold,
              ),
            ),
          ],
        ),
        Gap(12.h),

        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: prayers.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final item = prayers[index];
              final isNext = item.isNext;
              final isPast = item.isPast;
              final formattedTime = DateFormat('hh:mm a', context.locale.languageCode).format(item.time);

              return InkWell(
                onTap: () {
                  AppHaptics.light();
                  onPrayerTap?.call(index);
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  width: 95.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isNext
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isNext
                          ? appColors.accentGold
                          : (isPast
                              ? appColors.cardBorder.withValues(alpha: 0.5)
                              : appColors.cardBorder),
                      width: isNext ? 1.5 : 0.8,
                    ),
                    boxShadow: isNext
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : appColors.cardShadow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header: Prayer Name & Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.locale.languageCode == 'ar' ? item.nameAr : item.nameEn,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                              color: isPast
                                  ? appColors.textMuted
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          Icon(
                            isPast ? Icons.check_circle_rounded : item.icon,
                            size: 16.sp,
                            color: isNext
                                ? appColors.accentGold
                                : (isPast
                                    ? appColors.statusSuccess
                                    : theme.colorScheme.primary),
                          ),
                        ],
                      ),

                      // Time Text
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isPast
                              ? appColors.textMuted
                              : theme.colorScheme.onSurface,
                        ),
                      ),

                      // Status Pill
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 3.h),
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
                              ? (item.remainingTime.isNotEmpty
                                  ? item.remainingTime
                                  : 'prayer_next'.tr())
                              : (isPast ? 'prayer_done'.tr() : 'prayer_upcoming'.tr()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: isNext
                                ? Colors.black
                                : (isPast
                                    ? appColors.textMuted
                                    : appColors.accentGold),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
