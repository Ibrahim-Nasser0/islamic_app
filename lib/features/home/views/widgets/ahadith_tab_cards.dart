import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';

/// Daily highlighted Hadith banner card.
class DailyHadithHighlightCard extends StatelessWidget {
  final ThemeData theme;
  final AppThemeColors appColors;

  const DailyHadithHighlightCard({
    super.key,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                appColors.accentGold.withValues(alpha: 0.14),
                appColors.navActivePillBg,
              ],
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.4),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RubElHizbMark(size: 14.w, color: appColors.accentGold),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'hadith_of_the_day'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.accentGold,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(10.h),
              Text(
                'daily_hadith_text'.tr(),
                style: AppTypography.quranAyah.copyWith(
                  fontSize: 18.sp,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Gap(6.h),
              Text(
                'narrated_by_bukhari_muslim'.tr(),
                style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
              ),
            ],
          ),
        ),
        const ManuscriptCorners(inset: 8, length: 11),
      ],
    );
  }
}

/// Interactive Hadith collection book tile.
class HadithBookTile extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String countLabel;
  final ThemeData theme;
  final AppThemeColors appColors;

  const HadithBookTile({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.countLabel,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
            AppRouter.navigateTo(
              context,
              Routes.hadithReader,
              arguments: {'bookId': id, 'bookTitle': title},
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                OctagonalIconFrame(
                  size: 44,
                  child: Icon(
                    FlutterIslamicIcons.solidMohammad,
                    color: appColors.accentGold,
                    size: 19.sp,
                  ),
                ),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: appColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(8.w),
                Text(
                  countLabel,
                  style: TextStyle(fontSize: 11.sp, color: appColors.accentGold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
