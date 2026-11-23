import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';

/// Tab 1: Holy Quran Overview
class QuranTabView extends StatelessWidget {
  const QuranTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Last Read Banner
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: appColors.cardBorder),
              boxShadow: appColors.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.menu_book_rounded, color: theme.colorScheme.primary, size: 24.sp),
                ),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'last_read'.tr(),
                        style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                      ),
                      Gap(4.h),
                      Text(
                        'surah_al_kahf_last_read'.tr(),
                        style: AppTypography.h4.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: appColors.textMuted),
              ],
            ),
          ),
          Gap(18.h),

          // Surah List Sample
          Text(
            'surahs_of_quran'.tr(),
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(12.h),

          ...List.generate(4, (index) {
            final names = [
              'surah_al_fatiha'.tr(),
              'surah_al_baqarah'.tr(),
              'surah_ali_imran'.tr(),
              'surah_an_nisa'.tr(),
            ];
            final ayahs = [
              'ayahs_count'.tr(namedArgs: {'count': '7'}),
              'ayahs_count'.tr(namedArgs: {'count': '286'}),
              'ayahs_count'.tr(namedArgs: {'count': '200'}),
              'ayahs_count'.tr(namedArgs: {'count': '176'}),
            ];
            final places = ['makki'.tr(), 'madani'.tr(), 'madani'.tr(), 'madani'.tr()];

            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: appColors.cardBorder, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: appColors.badgeBackground,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: appColors.accentGold,
                        ),
                      ),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          names[index],
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          '${places[index]} • ${ayahs[index]}',
                          style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'surah'.tr(),
                    style: TextStyle(fontSize: 12.sp, color: appColors.accentGold),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
