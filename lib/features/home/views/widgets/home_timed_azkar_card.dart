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

/// Time-aware interactive Azkar Sanctuary card shared across Home & Azkar Tab.
class HomeTimedAzkarCard extends StatelessWidget {
  const HomeTimedAzkarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<TimedAzkarCubit, TimedAzkarState>(
      builder: (context, state) {
        if (state.isLoading || state.category == null) {
          return CustomSkeleton(height: 190.h, borderRadius: 18);
        }

        final cat = state.category!;
        final active = state.activeDhikr;
        final cubit = context.read<TimedAzkarCubit>();
        final ratio = cat.totalItems == 0
            ? 0.0
            : (cat.completedItems / cat.totalItems).clamp(0.0, 1.0);
        final currentStep = active == null
            ? cat.totalItems
            : (cat.items.indexWhere((i) => i.id == active.id) + 1)
                .clamp(1, cat.totalItems);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SanctuarySectionHeader(
              title: 'timed_azkar_title'.tr(),
              badgeText: '${cat.completedItems} / ${cat.totalItems}',
            ),
            Gap(10.h),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: active == null
                          ? appColors.statusSuccess.withValues(alpha: 0.4)
                          : appColors.accentGold.withValues(alpha: 0.32),
                      width: 0.9,
                    ),
                    boxShadow: appColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999.r),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 3.h,
                          backgroundColor: appColors.cardBorder.withValues(alpha: 0.35),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            active == null
                                ? appColors.statusSuccess
                                : appColors.accentGold,
                          ),
                        ),
                      ),
                      Gap(12.h),
                      TimedAzkarPeriodBar(state: state, cubit: cubit),
                      Gap(12.h),
                      if (active != null)
                        TimedAzkarDhikrBox(
                          active: active,
                          currentStep: currentStep,
                          totalItems: cat.totalItems,
                          onTap: cubit.decrementActiveDhikr,
                        )
                      else
                        _buildCompletedBox(context, cubit),
                    ],
                  ),
                ),
                const ManuscriptCorners(inset: 7, length: 10),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompletedBox(BuildContext context, TimedAzkarCubit cubit) {
    final appColors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: appColors.statusSuccess.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: appColors.statusSuccess.withValues(alpha: 0.35),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final resetBtn = TextButton(
            onPressed: () {
              AppHaptics.light();
              cubit.resetCurrentPeriod();
            },
            child: Text(
              'timed_azkar_reset'.tr(),
              style: TextStyle(fontSize: 11.5.sp),
            ),
          );
          final infoRow = Row(
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
                      style:
                          TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          );

          if (constraints.maxWidth < 280) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                infoRow,
                Align(alignment: AlignmentDirectional.centerEnd, child: resetBtn),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: infoRow),
              resetBtn,
            ],
          );
        },
      ),
    );
  }
}
