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

/// Tab 2: Azkar & Tasbeeh
class AzkarTabView extends StatelessWidget {
  const AzkarTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final azkarCategories = [
      {
        'id': 'morning',
        'title': 'azkar_morning'.tr(),
        'count': 'items_count'.tr(namedArgs: {'count': '8'}),
        'icon': Icons.wb_sunny_rounded,
      },
      {
        'id': 'evening',
        'title': 'azkar_evening'.tr(),
        'count': 'items_count'.tr(namedArgs: {'count': '7'}),
        'icon': FlutterIslamicIcons.solidCrescentMoon,
      },
      {
        'id': 'after_prayer',
        'title': 'azkar_after_prayer'.tr(),
        'count': 'items_count'.tr(namedArgs: {'count': '5'}),
        'icon': FlutterIslamicIcons.solidPrayer,
      },
      {
        'id': 'sleep',
        'title': 'azkar_sleep'.tr(),
        'count': 'items_count'.tr(namedArgs: {'count': '4'}),
        'icon': FlutterIslamicIcons.crescentMoon,
      },
      {
        'id': 'quranic_duas',
        'title': 'azkar_quranic_duas'.tr(),
        'count': 'items_count'.tr(namedArgs: {'count': '4'}),
        'icon': FlutterIslamicIcons.quran2,
      },
      {
        'id': 'tasbeeh',
        'title': 'smart_tasbeeh'.tr(),
        'count': 'tasbeeh_counter_desc'.tr(),
        'icon': FlutterIslamicIcons.solidTasbih,
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'azkar_sections_title'.tr(),
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(12.h),

          ...azkarCategories.map((cat) {
            final isTasbeeh = cat['id'] == 'tasbeeh';

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    AppHaptics.light();
                    if (isTasbeeh) {
                      AppRouter.navigateTo(context, Routes.tasbeeh);
                    } else {
                      AppRouter.navigateTo(
                        context,
                        Routes.azkarCategory,
                        arguments: {'categoryId': cat['id']},
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: appColors.cardBorder, width: 0.8),
                      boxShadow: appColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: appColors.badgeBackground,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: appColors.accentGold,
                            size: 22.sp,
                          ),
                        ),
                        Gap(14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat['title'] as String,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(4.h),
                              Text(
                                cat['count'] as String,
                                style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: appColors.textMuted),
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
