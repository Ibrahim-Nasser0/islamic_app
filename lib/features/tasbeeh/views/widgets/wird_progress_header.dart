import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';

/// Top HUD for Daily Wird displaying completion percentage and customization trigger
class WirdProgressHeader extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final double progress;
  final VoidCallback onCustomize;
  final VoidCallback onReset;

  const WirdProgressHeader({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
    required this.onCustomize,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final percent = (progress * 100).toInt();
    final isDone = progress >= 1.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDone
              ? appColors.statusSuccess.withValues(alpha: 0.6)
              : appColors.cardBorder,
          width: 0.8,
        ),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title & Counter with icon
              Row(
                children: [
                  Icon(
                    isDone ? Icons.verified_rounded : Icons.auto_stories_rounded,
                    size: 17.sp,
                    color: isDone ? appColors.statusSuccess : appColors.accentGold,
                  ),
                  Gap(8.w),
                  Text(
                    'wird_progress'.tr(namedArgs: {
                      'done': '$completedCount',
                      'total': '$totalCount',
                      'percent': '$percent',
                    }),
                    style: AppTypography.h5.copyWith(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isDone
                          ? appColors.statusSuccess
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              // Action Buttons: Customize & Reset
              Row(
                children: [
                  // Customize Pill
                  InkWell(
                    onTap: () {
                      AppHaptics.light();
                      onCustomize();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: appColors.accentGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: appColors.accentGold.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 14.sp,
                            color: appColors.accentGold,
                          ),
                          Gap(4.w),
                          Text(
                            'tap_to_customize'.tr(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: appColors.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(6.w),

                  // Reset Button
                  InkWell(
                    onTap: () async {
                      AppHaptics.heavy();
                      final confirmed = await AppDialogs.confirm(
                        context,
                        title: 'reset_confirm_title'.tr(),
                        message: 'reset_confirm_message'.tr(),
                        confirmText: 'reset_counter'.tr(),
                      );
                      if (confirmed == true) {
                        onReset();
                      }
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Padding(
                      padding: EdgeInsets.all(5.r),
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 20.sp,
                        color: appColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(10.h),

          // Animated Smooth Linear Progress Bar
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            builder: (context, value, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 5.5.h,
                  backgroundColor: appColors.cardBorder.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDone ? appColors.statusSuccess : appColors.accentGold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
