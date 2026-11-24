import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/widgets.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SanctuarySectionHeader(
          title: 'today_prayers'.tr(),
          badgeText: 'prayers_count'.tr(),
        ),
        Gap(12.h),

        // Horizontal List of Reusable Prayer Cards
        SizedBox(
          height: 126.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: prayers.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
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
