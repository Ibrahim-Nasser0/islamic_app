import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../azkar/presentation/cubit/timed_azkar_cubit.dart';
import '../../../azkar/presentation/cubit/timed_azkar_state.dart';
import 'timed_azkar_dhikr_box.dart';
import 'timed_azkar_period_bar.dart';

/// Time-aware interactive Azkar card rendered beneath HomeQuickActionsBar.
class HomeTimedAzkarCard extends StatelessWidget {
  const HomeTimedAzkarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<TimedAzkarCubit, TimedAzkarState>(
      builder: (context, state) {
        if (state.isLoading || state.category == null) {
          return CustomSkeleton(height: 170.h, borderRadius: 18);
        }

        final cat = state.category!;
        final active = state.activeDhikr;
        final cubit = context.read<TimedAzkarCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SanctuarySectionHeader(
              title: 'timed_azkar_title'.tr(),
              badgeText: '${cat.completedItems} / ${cat.totalItems}',
            ),
            Gap(10.h),
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: appColors.cardBorder, width: 0.9),
                boxShadow: appColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TimedAzkarPeriodBar(state: state, cubit: cubit),
                  Gap(10.h),
                  if (active != null)
                    TimedAzkarDhikrBox(
                      active: active,
                      onTap: cubit.decrementActiveDhikr,
                    )
                  else
                    _buildCompletedBox(context, cubit),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompletedBox(BuildContext context, TimedAzkarCubit cubit) {
    final appColors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: appColors.statusSuccess.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: appColors.statusSuccess.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            color: appColors.statusSuccess,
            size: 24.sp,
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'timed_azkar_done_title'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: appColors.statusSuccess,
                  ),
                ),
                Text(
                  'timed_azkar_done_desc'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              AppHaptics.light();
              cubit.resetCurrentPeriod();
            },
            child: Text(
              'timed_azkar_reset'.tr(),
              style: TextStyle(fontSize: 11.5.sp),
            ),
          ),
        ],
      ),
    );
  }
}
