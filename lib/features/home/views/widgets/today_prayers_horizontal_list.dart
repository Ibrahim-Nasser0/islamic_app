import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/prayer_time_entry.dart';
import 'prayer_time_card.dart';

/// Adaptive list displaying all prayers of the day:
/// horizontal strip on compact widths, 3x2 grid on wider containers.
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
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 500) {
              return _buildThreeByTwoGrid();
            }
            return _buildHorizontalStrip();
          },
        ),
      ],
    );
  }

  Widget _buildHorizontalStrip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(prayers.length, (index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: index < prayers.length - 1 ? 8.w : 0,
            ),
            child: PrayerTimeCard(
              prayer: prayers[index],
              onTap: () => onPrayerTap?.call(index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildThreeByTwoGrid() {
    final rows = <Widget>[];
    for (var i = 0; i < prayers.length; i += 3) {
      final end = (i + 3).clamp(0, prayers.length);
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: end < prayers.length ? 10.h : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(3, (col) {
              final idx = i + col;
              if (idx >= prayers.length) {
                return const Expanded(child: SizedBox.shrink());
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: col < 2 ? 10.w : 0,
                  ),
                  child: PrayerTimeCard(
                    prayer: prayers[idx],
                    width: double.infinity,
                    onTap: () => onPrayerTap?.call(idx),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
