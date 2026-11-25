import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/widgets.dart';

/// Inner content of the Astrolabe Dial medallion displaying round, tabular count, and target pill.
class TasbeehDialCenterContent extends StatelessWidget {
  final int count;
  final String cycleBadge;
  final String targetLabel;
  final double diameter;
  final bool activeHero;
  final bool isCompleted;
  final Color trackColor;

  const TasbeehDialCenterContent({
    super.key,
    required this.count,
    required this.cycleBadge,
    required this.targetLabel,
    required this.diameter,
    required this.activeHero,
    required this.isCompleted,
    required this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RubElHizbMark(
                size: 9.w,
                color: activeHero ? AppColors.accentLight : appColors.accentGold,
              ),
              Gap(5.w),
              Flexible(
                child: Text(
                  cycleBadge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: activeHero
                        ? AppColors.accentLight
                        : appColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          Gap(2.h),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$count',
                style: AppTypography.h1.copyWith(
                  fontSize: (diameter * 0.215).clamp(36.0, 54.0),
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: activeHero
                      ? AppColors.quranPage
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          Gap(4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 3.5.h),
            decoration: BoxDecoration(
              color: activeHero
                  ? AppColors.accentLight.withValues(alpha: 0.16)
                  : appColors.badgeBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: (activeHero ? AppColors.accentLight : trackColor)
                    .withValues(alpha: 0.35),
                width: 0.7,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted) ...[
                    Icon(
                      Icons.check_circle_rounded,
                      size: 12.sp,
                      color: AppColors.accentLight,
                    ),
                    Gap(4.w),
                  ],
                  Text(
                    targetLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: activeHero ? AppColors.accentLight : trackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
