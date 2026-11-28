import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/hadith_item.dart';
import 'hadith_grade_badge.dart';

class HadithCardItem extends StatelessWidget {
  final HadithItem hadith;
  final VoidCallback onTap;

  const HadithCardItem({
    super.key,
    required this.hadith,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppHaptics.light();
            onTap();
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNumberBadge(context),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hadith.title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (hadith.chapter != null)
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: appColors.badgeBackground,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  hadith.chapter!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: appColors.accentGold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Gap(4.h),
                      Text(
                        hadith.narrator,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: appColors.accentGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(6.h),
                      Text(
                        hadith.arabicText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.6,
                          color: appColors.textMuted,
                        ),
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hadith.reference,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: appColors.textMuted,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Gap(8.w),
                          HadithGradeBadge(hadith: hadith, compact: true),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: appColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberBadge(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        color: appColors.badgeBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '${hadith.number}',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
