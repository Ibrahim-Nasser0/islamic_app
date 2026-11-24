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

/// Period selector pills and "Open All" link for the time-aware Azkar card.
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
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AzkarTimePeriod.values.map((p) {
                final selected = p == state.selectedPeriod;
                final isNow = p == state.recommendedPeriod;
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 6.w),
                  child: InkWell(
                    onTap: () {
                      AppHaptics.selection();
                      cubit.selectPeriod(p);
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: selected
                            ? appColors.navActivePillBg
                            : appColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: selected
                              ? appColors.accentGold.withValues(alpha: 0.55)
                              : appColors.cardBorder,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isNow) ...[
                            RubElHizbMark(
                                size: 10.w, color: appColors.accentGold),
                            Gap(4.w),
                          ],
                          Text(
                            p.titleKey.tr(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight:
                                  selected ? FontWeight.bold : FontWeight.w500,
                              color: selected
                                  ? appColors.accentGold
                                  : appColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Gap(6.w),
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
            child: Text(
              'timed_azkar_open_all'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: appColors.accentGold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
