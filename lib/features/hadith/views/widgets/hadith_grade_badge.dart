import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/hadith_item.dart';

/// Scholarly Hadith grade pill with Islamic diamond certainty facets (`◆`).
class HadithGradeBadge extends StatelessWidget {
  final HadithItem hadith;
  final bool compact;

  const HadithGradeBadge({
    super.key,
    required this.hadith,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final tone = resolveTone(appColors, hadith.gradeTier);
    final label = hadith.localizedGradeLabel(context.locale.languageCode);
    final isCitationOnly = hadith.gradeTier == HadithItem.tierCitationInText;
    final filledCount = hadith.strengthScore.clamp(1, 4);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9.w : 11.w,
        vertical: compact ? 4.h : 5.h,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: tone.withValues(alpha: 0.35),
          width: 0.85,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(resolveIcon(hadith.gradeTier), size: compact ? 13.sp : 15.sp, color: tone),
            Gap(5.w),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 10.sp : 11.5.sp,
                fontWeight: FontWeight.w700,
                color: tone,
              ),
            ),
            if (!isCitationOnly) ...[
              Gap(6.w),
              _DiamondStrengthRow(
                filled: filledCount,
                activeColor: tone,
                borderColor: tone.withValues(alpha: 0.45),
              ),
              Gap(4.w),
              Text(
                '$filledCount/4',
                style: TextStyle(
                  fontSize: compact ? 9.5.sp : 10.5.sp,
                  fontWeight: FontWeight.w800,
                  color: tone,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Color resolveTone(AppThemeColors appColors, String tier) =>
      switch (tier) {
        HadithItem.tierMuttafaq => appColors.accentGold,
        HadithItem.tierSahih => appColors.statusSuccess,
        HadithItem.tierHasanSahih || HadithItem.tierHasan => appColors.statusWarning,
        _ => appColors.statusInfo,
      };

  static IconData resolveIcon(String tier) => switch (tier) {
        HadithItem.tierMuttafaq => Icons.workspace_premium_rounded,
        HadithItem.tierSahih => Icons.verified_rounded,
        HadithItem.tierHasanSahih || HadithItem.tierHasan => Icons.shield_rounded,
        _ => Icons.menu_book_rounded,
      };
}

class _DiamondStrengthRow extends StatelessWidget {
  final int filled;
  final Color activeColor;
  final Color borderColor;

  const _DiamondStrengthRow({
    required this.filled,
    required this.activeColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (i) {
        final isFilled = i < filled;
        return Padding(
          padding: EdgeInsetsDirectional.only(end: i == 3 ? 0 : 2.5.w),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 5.5.w,
              height: 5.5.w,
              decoration: BoxDecoration(
                color: isFilled ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(1.2.r),
                border: Border.all(
                  color: isFilled ? activeColor : borderColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
