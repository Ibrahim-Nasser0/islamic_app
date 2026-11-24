import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/animations/button_animation.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../quran/domain/entities/daily_wird_verse.dart';
import '../../../quran/presentation/cubit/daily_wird_cubit.dart';

/// Progress bar and dual action buttons (Mission Complete + Next Verses) for Daily Quran Wird.
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
        Gap(5.h),
        Text(
          'daily_wird_progress'.tr(namedArgs: {
            'current': '${slice.endGlobalAyah}',
            'total': '${slice.totalQuranVerses}',
          }),
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 10.5.sp, color: appColors.textMuted),
        ),
        Gap(14.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomButton(
                height: 46.h,
                fontSize: 12.5.sp,
                text: completed
                    ? 'daily_wird_completed_badge'.tr()
                    : 'daily_wird_complete_btn'.tr(),
                icon: completed ? Icons.verified_rounded : Icons.task_alt_rounded,
                color: completed
                    ? appColors.statusSuccess
                    : theme.colorScheme.primary,
                onPressed: () {
                  if (completed) return;
                  AppHaptics.medium();
                  cubit.markCompleted();
                },
              ).buttonAnimation(),
            ),
            Gap(10.w),
            Expanded(
              flex: 2,
              child: CustomButton(
                height: 46.h,
                fontSize: 12.5.sp,
                isOutlined: true,
                color: appColors.accentGold,
                text: 'daily_wird_next_btn'.tr(),
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  AppHaptics.selection();
                  cubit.moveToNextBatch();
                },
              ).buttonAnimation(),
            ),
          ],
        ),
      ],
    );
  }
}
