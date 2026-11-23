import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/juz_info.dart';

/// Card item representing a single Juz in the Quran Index
class JuzCardItem extends StatelessWidget {
  final JuzInfo juz;
  final VoidCallback onTap;

  const JuzCardItem({
    super.key,
    required this.juz,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: InkWell(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Juz Badge
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: appColors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${juz.number}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: appColors.accentGold,
                  ),
                ),
              ),
              Gap(12.w),

              // Juz Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${"juz".tr()} ${juz.number}',
                      style: AppTypography.h5.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(3.h),
                    Text(
                      '${"starts_from".tr()}: ${juz.startSurahName} (آية ${juz.startVerseNumber})',
                      style: TextStyle(fontSize: 11.5.sp, color: appColors.textMuted),
                    ),
                  ],
                ),
              ),

              // Page Number Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: appColors.badgeBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'ص ${juz.pageNumber}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: appColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
