import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/responsive/responsive_content_frame.dart';
import '../../../../core/responsive/window_size_class.dart';
import '../../../../core/services/native/permission_readiness_cubit.dart';
import '../../../../core/widgets/custom_skeleton.dart';
import '../../../azkar/presentation/cubit/timed_azkar_cubit.dart';
import '../../../quran/presentation/cubit/daily_wird_cubit.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import '../../presentation/cubit/prayer_times_state.dart';
import 'home_daily_wird_card.dart';
import 'home_location_handler.dart';
import 'home_permission_banner.dart';
import 'home_quick_actions_bar.dart';
import 'home_timed_azkar_card.dart';
import 'kaaba_atmospheric_hero_card.dart';
import 'today_prayers_horizontal_list.dart';

/// Tab 0: Home & Prayer Times with Time-Aware Azkar and Daily Wird.
class HomePrayerView extends StatelessWidget {
  const HomePrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PrayerTimesCubit>()..loadPrayerTimes()),
        BlocProvider(create: (_) => sl<PermissionReadinessCubit>()..refresh()),
        BlocProvider(create: (_) => sl<TimedAzkarCubit>()..loadForCurrentTime()),
        BlocProvider.value(value: sl<DailyWirdCubit>()..loadWird()),
      ],
      child: const _HomePrayerContent(),
    );
  }
}

class _HomePrayerContent extends StatelessWidget {
  const _HomePrayerContent();

  @override
  Widget build(BuildContext context) {
    final bottomPad = context.bottomNavClearance();

    return BlocListener<PrayerTimesCubit, PrayerTimesState>(
      listener: (context, state) {
        if (state is PrayerTimesLoaded) {
          context
              .read<TimedAzkarCubit>()
              .loadForCurrentTime(schedule: state.schedule);
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(top: 14.h, bottom: bottomPad),
        child: ResponsiveContentFrame(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth >= 720;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomePermissionBanner(
                    onPermissionsUpdated: () =>
                        context.read<PrayerTimesCubit>().refreshLocation(),
                  ),
                  if (twoColumns)
                    _buildExpandedLayout(context)
                  else
                    _buildCompactLayout(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeroCard(context),
        Gap(20.h),
        _buildPrayersList(context),
        Gap(24.h),
        const HomeQuickActionsBar(),
        Gap(24.h),
        const HomeTimedAzkarCard(),
        Gap(24.h),
        const HomeDailyWirdCard(),
      ],
    );
  }

  Widget _buildExpandedLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroCard(context),
              Gap(20.h),
              _buildPrayersList(context),
            ],
          ),
        ),
        Gap(20.w),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeQuickActionsBar(),
              Gap(20.h),
              const HomeTimedAzkarCard(),
              Gap(20.h),
              const HomeDailyWirdCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
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

  Widget _buildPrayersList(BuildContext context) {
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
