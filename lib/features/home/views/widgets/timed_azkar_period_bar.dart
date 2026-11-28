import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../azkar/presentation/cubit/timed_azkar_cubit.dart';
import '../../../azkar/presentation/cubit/timed_azkar_state.dart';

/// Unified [CustomSegmentedControl] period picker + active slot badge & Open-All link.
class TimedAzkarPeriodBar extends StatelessWidget {
  final TimedAzkarState state;
  final TimedAzkarCubit cubit;

  const TimedAzkarPeriodBar({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    const periods = AzkarTimePeriod.values;
    final selectedIdx = periods.indexOf(state.selectedPeriod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (state.isRecommendedActive)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: appColors.accentGold.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RubElHizbMark(size: 11.w, color: appColors.accentGold),
                    Gap(5.w),
                    Text(
                      'timed_azkar_now_badge'.tr(),
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.accentGold,
                      ),
                    ),
                  ],
                ),
              )
            else
              InkWell(
                onTap: () {
                  AppHaptics.selection();
                  cubit.selectPeriod(state.recommendedPeriod);
                },
                borderRadius: BorderRadius.circular(999.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    'timed_azkar_current_slot_badge'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: appColors.textMuted,
                    ),
                  ),
                ),
              ),
            const Spacer(),
            InkWell(
              onTap: () async {
                AppHaptics.light();
                await Navigator.pushNamed(
                  context,
                  Routes.azkarCategory,
                  arguments: {'categoryId': state.selectedPeriod.categoryId},
                );
                if (context.mounted) cubit.reloadCurrent();
              },
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'timed_azkar_open_all'.tr(),
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.accentGold,
                      ),
                    ),
                    Gap(3.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11.sp,
                      color: appColors.accentGold,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Gap(10.h),
        CustomSegmentedControl(
          height: 38.h,
          options: periods.map((p) => p.titleKey.tr()).toList(),
          selectedIndex: selectedIdx < 0 ? 0 : selectedIdx,
          onValueChanged: (idx) => cubit.selectPeriod(periods[idx]),
        ),
      ],
    );
  }
}
