import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/hadith_item.dart';
import 'hadith_grade_badge.dart';

/// Detailed 4-stage scholarly authenticity panel displayed inside [HadithDetailScreen].
class HadithStrengthMeterCard extends StatelessWidget {
  final HadithItem hadith;

  const HadithStrengthMeterCard({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final tone = HadithGradeBadge.resolveTone(appColors, hadith.gradeTier);
    final stageReached = _stageForTier(hadith.gradeTier);
    final stages = [
      'hadith_stage_citation'.tr(),
      'hadith_stage_hasan'.tr(),
      'hadith_stage_sahih'.tr(),
      'hadith_stage_muttafaq'.tr(),
    ];

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: tone.withValues(alpha: 0.35), width: 0.9),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                HadithGradeBadge.resolveIcon(hadith.gradeTier),
                color: tone,
                size: 18.sp,
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  'hadith_strength_meter_title'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              HadithGradeBadge(hadith: hadith, compact: true),
            ],
          ),
          Gap(12.h),
          Row(
            children: List.generate(stages.length, (i) {
              final active = i < stageReached;
              final isCurrent = i == stageReached - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: i == 3 ? 0 : 6.w),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: active
                              ? tone
                              : appColors.cardBorder.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                      Gap(5.h),
                      Text(
                        stages[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: isCurrent ? tone : appColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          Gap(10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              _descriptionKeyForTier(hadith.gradeTier).tr(),
              style: TextStyle(
                fontSize: 11.5.sp,
                height: 1.45,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static int _stageForTier(String tier) => switch (tier) {
        HadithItem.tierMuttafaq => 4,
        HadithItem.tierSahih => 3,
        HadithItem.tierHasanSahih || HadithItem.tierHasan => 2,
        _ => 1,
      };

  static String _descriptionKeyForTier(String tier) => switch (tier) {
        HadithItem.tierMuttafaq => 'hadith_grade_muttafaq_desc',
        HadithItem.tierSahih => 'hadith_grade_sahih_desc',
        HadithItem.tierHasanSahih ||
        HadithItem.tierHasan =>
          'hadith_grade_hasan_desc',
        _ => 'hadith_grade_citation_desc',
      };
}
