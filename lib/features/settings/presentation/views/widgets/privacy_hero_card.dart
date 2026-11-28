import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/islamic/octagonal_icon_frame.dart';

/// Top sanctuary summary banner explaining Zad Al-Muslim's privacy commitment.
class PrivacyHeroCard extends StatelessWidget {
  const PrivacyHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.35),
          width: 0.9,
        ),
        boxShadow: appColors.cardShadow,
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            theme.colorScheme.surface,
            appColors.surfaceSubtle,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OctagonalIconFrame(
                size: 46,
                active: true,
                child: Icon(
                  Icons.shield_outlined,
                  size: 22.sp,
                  color: appColors.accentGold,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'privacy_hero_title'.tr(),
                      style: AppTypography.h4.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      'privacy_last_updated'.tr(),
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: appColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.22),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  size: 14.sp,
                  color: theme.colorScheme.primary,
                ),
                Gap(6.w),
                Flexible(
                  child: Text(
                    'privacy_hero_badge'.tr(),
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(12.h),
          Text(
            'privacy_hero_summary'.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.55,
              color: appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
