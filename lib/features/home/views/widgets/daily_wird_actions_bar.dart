import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/animations/button_animation.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../quran/domain/entities/daily_wird_verse.dart';
import '../../../quran/presentation/cubit/daily_wird_cubit.dart';

/// Progress bar and Celestial Sanctuary dual action buttons for Daily Quran Wird.
class DailyWirdActionsBar extends StatelessWidget {
  final DailyWirdSlice slice;
  final DailyWirdCubit cubit;
  final bool completed;

  const DailyWirdActionsBar({
    super.key,
    required this.slice,
    required this.cubit,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    final completeBtn = CustomButton(
      height: 44.h,
      borderRadius: 12,
      fontSize: 13.sp,
      text: completed
          ? 'daily_wird_completed_badge'.tr()
          : 'daily_wird_complete_btn'.tr(),
      icon: completed ? Icons.verified_rounded : Icons.task_alt_rounded,
      gradient: completed
          ? null
          : LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [appColors.emeraldBevelTop, appColors.emeraldBevelBottom],
            ),
      color: completed ? appColors.statusSuccess.withValues(alpha: 0.12) : null,
      borderColor: completed
          ? appColors.statusSuccess.withValues(alpha: 0.4)
          : appColors.accentGold.withValues(alpha: 0.45),
      borderWidth: 0.9,
      textColor: completed ? appColors.statusSuccess : AppColors.quranPage,
      iconColor: completed ? appColors.statusSuccess : AppColors.accentLight,
      onPressed: completed
          ? null
          : () {
              AppHaptics.medium();
              cubit.markCompleted();
            },
    ).buttonAnimation();

    final nextBtn = CustomButton(
      height: 44.h,
      borderRadius: 12,
      fontSize: 12.5.sp,
      color: appColors.surfaceSubtle,
      borderColor: appColors.cardBorder,
      borderWidth: 0.9,
      textColor: theme.colorScheme.onSurface,
      iconColor: appColors.accentGold,
      text: 'daily_wird_next_btn'.tr(),
      icon: Icons.navigate_next_rounded,
      iconAfterText: true,
      onPressed: () {
        AppHaptics.selection();
        cubit.moveToNextBatch();
      },
    ).buttonAnimation();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: slice.khatmahProgress,
            minHeight: 5.h,
            backgroundColor: appColors.surfaceSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(appColors.accentGold),
          ),
        ),
        Gap(6.h),
        Text(
          'daily_wird_progress'.tr(namedArgs: {
            'current': '${slice.endGlobalAyah}',
            'total': '${slice.totalQuranVerses}',
          }),
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 10.5.sp, color: appColors.textMuted),
        ),
        Gap(14.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final stackVertically =
                constraints.maxWidth < 290 || textScale >= 1.22;
            if (stackVertically) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  completeBtn,
                  Gap(8.h),
                  nextBtn,
                ],
              );
            }
            return Row(
              children: [
                Expanded(flex: 5, child: completeBtn),
                Gap(10.w),
                Expanded(flex: 4, child: nextBtn),
              ],
            );
          },
        ),
      ],
    );
  }
}
