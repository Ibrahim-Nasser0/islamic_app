import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/responsive/responsive_card_grid.dart';
import '../../../../core/responsive/responsive_content_frame.dart';
import '../../../../core/responsive/window_size_class.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';

/// Tab 2: Azkar & Tasbeeh
class AzkarTabView extends StatelessWidget {
  const AzkarTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final bottomPad = context.bottomNavClearance();

    final azkarCategories = [
      _AzkarItem('morning', 'azkar_morning'.tr(), '8', Icons.wb_sunny_rounded),
      _AzkarItem(
        'evening',
        'azkar_evening'.tr(),
        '7',
        FlutterIslamicIcons.solidCrescentMoon,
      ),
      _AzkarItem(
        'after_prayer',
        'azkar_after_prayer'.tr(),
        '5',
        FlutterIslamicIcons.solidPrayer,
      ),
      _AzkarItem(
        'sleep',
        'azkar_sleep'.tr(),
        '4',
        FlutterIslamicIcons.crescentMoon,
      ),
      _AzkarItem(
        'quranic_duas',
        'azkar_quranic_duas'.tr(),
        '4',
        FlutterIslamicIcons.quran2,
      ),
      _AzkarItem(
        'tasbeeh',
        'smart_tasbeeh'.tr(),
        null,
        FlutterIslamicIcons.solidTasbih,
      ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 16.h, bottom: bottomPad),
      child: ResponsiveContentFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SanctuarySectionHeader(title: 'azkar_sections_title'.tr()),
            Gap(14.h),
            ResponsiveCardGrid(
              children: azkarCategories.map((cat) {
                return _AzkarCategoryTile(
                  item: cat,
                  theme: theme,
                  appColors: appColors,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AzkarItem {
  final String id;
  final String title;
  final String? count;
  final IconData icon;
  const _AzkarItem(this.id, this.title, this.count, this.icon);
  bool get isTasbeeh => id == 'tasbeeh';
}

class _AzkarCategoryTile extends StatelessWidget {
  final _AzkarItem item;
  final ThemeData theme;
  final AppThemeColors appColors;

  const _AzkarCategoryTile({
    required this.item,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = item.isTasbeeh
        ? 'tasbeeh_counter_desc'.tr()
        : 'items_count'.tr(namedArgs: {'count': item.count ?? '0'});

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppHaptics.light();
            if (item.isTasbeeh) {
              AppRouter.navigateTo(context, Routes.tasbeeh);
            } else {
              AppRouter.navigateTo(
                context,
                Routes.azkarCategory,
                arguments: {'categoryId': item.id},
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
                OctagonalIconFrame(
                  size: 44,
                  active: item.isTasbeeh,
                  child: Icon(
                    item.icon,
                    color: appColors.accentGold,
                    size: 20.sp,
                  ),
                ),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(4.h),
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
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: appColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
