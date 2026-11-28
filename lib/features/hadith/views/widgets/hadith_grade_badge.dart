import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/hadith_item.dart';

/// Scholarly Hadith grade pill with restrained 4-bar strength indicator.
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
    final tone = _resolveTone(appColors, hadith.gradeTier);
    final label = hadith.localizedGradeLabel(context.locale.languageCode);
    final hasScale = hadith.gradeTier != HadithItem.tierCitationInText;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8.w : 10.w,
        vertical: compact ? 3.h : 5.h,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: tone.withValues(alpha: 0.32),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_resolveIcon(hadith.gradeTier), size: compact ? 12.sp : 14.sp, color: tone),
          Gap(5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10.sp : 11.5.sp,
              fontWeight: FontWeight.w700,
              color: tone,
            ),
          ),
          if (hasScale) ...[
            Gap(6.w),
            _StrengthBars(
              score: hadith.strengthScore,
              activeColor: tone,
              inactiveColor: appColors.cardBorder,
            ),
            if (!compact) ...[
              Gap(5.w),
              Text(
                'hadith_strength_scale'.tr(
                  namedArgs: {'score': '${hadith.strengthScore}'},
                ),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: tone,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  static Color _resolveTone(AppThemeColors appColors, String tier) =>
      switch (tier) {
        HadithItem.tierMuttafaq => appColors.accentGold,
        HadithItem.tierSahih => appColors.statusSuccess,
        HadithItem.tierHasanSahih || HadithItem.tierHasan => appColors.statusWarning,
        _ => appColors.statusInfo,
      };

  static IconData _resolveIcon(String tier) => switch (tier) {
        HadithItem.tierMuttafaq || HadithItem.tierSahih => Icons.verified_rounded,
        HadithItem.tierHasanSahih ||
        HadithItem.tierHasan =>
          Icons.check_circle_outline_rounded,
        _ => Icons.menu_book_rounded,
      };
}

class _StrengthBars extends StatelessWidget {
  final int score;
  final Color activeColor;
  final Color inactiveColor;

  const _StrengthBars({
    required this.score,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        final filled = i < score;
        return Container(
          width: 3.w,
          height: (6 + i * 2).h,
          margin: EdgeInsets.only(right: i == 3 ? 0 : 1.5.w),
          decoration: BoxDecoration(
            color: filled ? activeColor : inactiveColor.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(1.5.r),
          ),
        );
      }),
    );
  }
}
