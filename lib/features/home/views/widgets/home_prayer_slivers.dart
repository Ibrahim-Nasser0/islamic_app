import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/responsive/responsive_content_frame.dart';
import '../../../../core/widgets/custom_skeleton.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import '../../presentation/cubit/prayer_times_state.dart';
import 'daily_hadith_highlight_card.dart';
import 'home_daily_wird_card.dart';
import 'home_location_handler.dart';
import 'home_permission_banner.dart';
import 'home_quick_actions_bar.dart';
import 'home_staggered_entry.dart';
import 'home_timed_azkar_card.dart';
import 'kaaba_atmospheric_hero_card.dart';
import 'today_prayers_horizontal_list.dart';

/// Builds adaptive Slivers for [HomePrayerView]'s [CustomScrollView].
class HomePrayerSlivers {
  const HomePrayerSlivers._();

  static List<Widget> build(
    BuildContext context, {
    required GlobalKey heroKey,
    required double bottomClearance,
  }) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: ResponsiveContentFrame(
            child: HomePermissionBanner(
              onPermissionsUpdated: () =>
                  context.read<PrayerTimesCubit>().refreshLocation(),
            ),
          ),
        ),
      ),
      SliverLayoutBuilder(
        builder: (context, sliverConstraints) {
          final twoColumns = sliverConstraints.crossAxisExtent >= 720;
          if (twoColumns) {
            return SliverToBoxAdapter(
              child: ResponsiveContentFrame(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HomeStaggeredEntry(
                            index: 0,
                            child: KeyedSubtree(key: heroKey, child: const _HeroCardSlot()),
                          ),
                          Gap(20.h),
                          const HomeStaggeredEntry(index: 1, child: _PrayersListSlot()),
                          Gap(20.h),
                          const HomeStaggeredEntry(index: 5, child: DailyHadithHighlightCard()),
                        ],
                      ),
                    ),
                    Gap(20.w),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const HomeStaggeredEntry(index: 2, child: HomeQuickActionsBar()),
                          Gap(20.h),
                          const HomeStaggeredEntry(index: 3, child: HomeTimedAzkarCard()),
                          Gap(20.h),
                          const HomeStaggeredEntry(index: 4, child: HomeDailyWirdCard()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildListDelegate.fixed([
              ResponsiveContentFrame(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeStaggeredEntry(
                      index: 0,
                      child: KeyedSubtree(key: heroKey, child: const _HeroCardSlot()),
                    ),
                    Gap(20.h),
                    const HomeStaggeredEntry(index: 1, child: _PrayersListSlot()),
                    Gap(24.h),
                    const HomeStaggeredEntry(index: 2, child: HomeQuickActionsBar()),
                    Gap(24.h),
                    const HomeStaggeredEntry(index: 3, child: HomeTimedAzkarCard()),
                    Gap(24.h),
                    const HomeStaggeredEntry(index: 4, child: HomeDailyWirdCard()),
                    Gap(24.h),
                    const HomeStaggeredEntry(index: 5, child: DailyHadithHighlightCard()),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
      SliverToBoxAdapter(child: SizedBox(height: bottomClearance)),
    ];
  }
}

class _HeroCardSlot extends StatelessWidget {
  const _HeroCardSlot();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoaded) {
          final schedule = state.schedule;
          final next = schedule.nextPrayer;
          final prev = schedule.currentPrayer;
          final lang = context.locale.languageCode;
          final isAr = lang == 'ar';
          final prevLabel = prev == null
              ? null
              : '${isAr ? prev.nameAr : prev.nameEn} ${DateFormat('hh:mm a', lang).format(prev.time)}';
          return KaabaAtmosphericHeroCard(
            location: schedule.getLocalizedLocation(lang),
            hijriDate: schedule.getHijriDate(lang),
            gregorianDate: DateFormat('d MMMM yyyy', lang).format(schedule.date),
            nextPrayerName: isAr ? next.nameAr : next.nameEn,
            nextPrayerTime: DateFormat('hh:mm a', lang).format(next.time),
            remainingTime: state.formattedRemainingTime,
            prevPrayerLabel: prevLabel,
            intervalProgress: state.intervalProgress,
            isManualLocation: state.isManualLocation,
            isRefreshingLocation: state.isRefreshingLocation,
            onLocationTap: () => handleHomeLocationTap(context),
          );
        }
        return CustomSkeleton(height: 220.h, borderRadius: 24);
      },
    );
  }
}

class _PrayersListSlot extends StatelessWidget {
  const _PrayersListSlot();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      buildWhen: (prev, curr) =>
          !(prev is PrayerTimesLoaded && curr is PrayerTimesLoaded) ||
          prev.schedule != curr.schedule,
      builder: (context, state) {
        if (state is PrayerTimesLoaded) {
          return TodayPrayersHorizontalList(prayers: state.schedule.prayers);
        }
        return CustomSkeleton(height: 124.h, borderRadius: 17);
      },
    );
  }
}
