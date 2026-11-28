import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';

class AzkarTabCategoryItem {
  final String id;
  final String title;
  final String? count;
  final IconData icon;

  const AzkarTabCategoryItem(this.id, this.title, this.count, this.icon);

  bool get isTasbeeh => id == 'tasbeeh';
}

/// Interactive chapter card in [AzkarTabView] with optional active time-slot highlight.
class AzkarTabCategoryTile extends StatelessWidget {
  final AzkarTabCategoryItem item;
  final bool isRecommendedNow;

  const AzkarTabCategoryTile({
    super.key,
    required this.item,
    this.isRecommendedNow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
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
              border: Border.all(
                color: isRecommendedNow
                    ? appColors.accentGold.withValues(alpha: 0.45)
                    : appColors.cardBorder,
                width: isRecommendedNow ? 1.0 : 0.8,
              ),
              boxShadow: appColors.cardShadow,
            ),
            child: Row(
              children: [
                OctagonalIconFrame(
                  size: 44,
                  active: item.isTasbeeh || isRecommendedNow,
                  child: Icon(item.icon, color: appColors.accentGold, size: 20.sp),
                ),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isRecommendedNow) ...[
                            Gap(6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: appColors.accentGold.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                'timed_azkar_now_badge'.tr(),
                                style: TextStyle(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: appColors.accentGold,
                                ),
                              ),
                            ),
                          ],
                        ],
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
                Gap(8.w),
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
