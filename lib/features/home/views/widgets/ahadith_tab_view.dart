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

/// Tab 3: Prophetic Ahadith Collection
class AhadithTabView extends StatelessWidget {
  const AhadithTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final books = [
      {
        'id': 'nawawi_forty',
        'title': 'nawawi_forty'.tr(),
        'subtitle': 'nawawi_forty_subtitle'.tr(),
        'count': 'hadiths_count'.tr(namedArgs: {'count': '42'}),
      },
      {
        'id': 'sahih_bukhari',
        'title': 'sahih_bukhari'.tr(),
        'subtitle': 'sahih_bukhari_subtitle'.tr(),
        'count': 'hadiths_count'.tr(namedArgs: {'count': '100'}),
      },
      {
        'id': 'sahih_muslim',
        'title': 'sahih_muslim'.tr(),
        'subtitle': 'sahih_muslim_subtitle'.tr(),
        'count': 'hadiths_count'.tr(namedArgs: {'count': '100'}),
      },
      {
        'id': 'riyad_assalihin',
        'title': 'riyad_assalihin'.tr(),
        'subtitle': 'riyad_assalihin_subtitle'.tr(),
        'count': 'hadiths_count'.tr(namedArgs: {'count': '100'}),
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Daily Hadith Highlight
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appColors.accentGold.withValues(alpha: 0.15),
                  theme.colorScheme.primary.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
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
                    Icon(
                      FlutterIslamicIcons.mohammad,
                      size: 20.sp,
                      color: appColors.accentGold,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'hadith_of_the_day'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.accentGold,
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
          Gap(20.h),

          Text(
            'hadith_books_title'.tr(),
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(12.h),

          ...books.map((book) {
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
                      arguments: {
                        'bookId': book['id'],
                        'bookTitle': book['title'],
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            FlutterIslamicIcons.solidMohammad,
                            color: theme.colorScheme.primary,
                            size: 20.sp,
                          ),
                        ),
                        Gap(14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book['title'] as String,
                                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                              ),
                              Gap(2.h),
                              Text(
                                book['subtitle'] as String,
                                style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          book['count'] as String,
                          style: TextStyle(fontSize: 11.sp, color: appColors.accentGold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
