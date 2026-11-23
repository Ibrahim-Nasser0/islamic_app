import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/prayer_time_entry.dart';
import 'prayer_time_card.dart';

/// Horizontal Row List displaying all prayers of the day using the unified PrayerTimeCard
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
        // Section Header
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

        // Horizontal List of Reusable Prayer Cards
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: prayers.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final prayer = prayers[index];
              return PrayerTimeCard(
                prayer: prayer,
                onTap: () => onPrayerTap?.call(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
