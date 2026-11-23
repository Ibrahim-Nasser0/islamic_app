import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_skeleton.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import '../../presentation/cubit/prayer_times_state.dart';
import 'home_quick_actions_bar.dart';
import 'kaaba_atmospheric_hero_card.dart';
import 'today_prayers_horizontal_list.dart';

/// Tab 0: Home & Prayer Times connected to PrayerTimesCubit with live countdown
class HomePrayerView extends StatelessWidget {
  const HomePrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PrayerTimesCubit>()..loadPrayerTimes(),
      child: const _HomePrayerContent(),
    );
  }
}

class _HomePrayerContent extends StatelessWidget {
  const _HomePrayerContent();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 110.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Dynamic Hero Card with Live Countdown
          BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            builder: (context, state) {
              if (state is PrayerTimesLoaded) {
                final schedule = state.schedule;
                final next = schedule.nextPrayer;
                final nextName = context.locale.languageCode == 'ar'
                    ? next.nameAr
                    : next.nameEn;
                final nextTimeStr = DateFormat(
                  'hh:mm a',
                  context.locale.languageCode,
                ).format(next.time);

                return KaabaAtmosphericHeroCard(
                  location: schedule.locationName,
                  hijriDate: schedule.hijriDate,
                  gregorianDate: schedule.gregorianDate,
                  nextPrayerName: nextName,
                  nextPrayerTime: nextTimeStr,
                  remainingTime: 'متبقي ${state.formattedRemainingTime}',
                  onLocationTap: () =>
                      context.read<PrayerTimesCubit>().refreshLocation(),
                );
              }

              // Loading Shimmer Skeleton
              return CustomSkeleton(
                height: 220.h,
                borderRadius: 24,
              );
            },
          ),
          Gap(20.h),

          // 2. Horizontal Prayers List Row
          BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            buildWhen: (prev, curr) {
              if (prev is PrayerTimesLoaded && curr is PrayerTimesLoaded) {
                // Only rebuild list if prayers change or once a minute
                return prev.schedule != curr.schedule;
              }
              return true;
            },
            builder: (context, state) {
              if (state is PrayerTimesLoaded) {
                return TodayPrayersHorizontalList(
                  prayers: state.schedule.prayers,
                );
              }

              // Loading Shimmer Skeleton for prayers row
              return CustomSkeleton(
                height: 120.h,
                borderRadius: 16,
              );
            },
          ),
          Gap(24.h),

          // 3. Quick Action Cards
          const HomeQuickActionsBar(),
          Gap(20.h),

          // 4. Daily Ayah Card
          _buildDailyAyahCard(appColors),
        ],
      ),
    );
  }

  Widget _buildDailyAyahCard(dynamic appColors) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: appColors.quranPageBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                size: 18.sp,
                color: appColors.accentGold,
              ),
              SizedBox(width: 8.w),
              Text(
                'daily_ayah'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: appColors.accentGold,
                ),
              ),
            ],
          ),
          Gap(12.h),
          Text(
            '﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾',
            textAlign: TextAlign.center,
            style: AppTypography.quranAyah.copyWith(
              fontSize: 20.sp,
              color: appColors.quranAyahText,
            ),
          ),
          Gap(6.h),
          Text(
            '[ الرعد: 28 ]',
            style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
          ),
        ],
      ),
    );
  }
}
