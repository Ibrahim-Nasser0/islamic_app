import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/wird_item.dart';

/// Horizontal list showing all enabled Wird items with progress and completion badges
class WirdItemsHorizontalList extends StatelessWidget {
  final List<WirdItem> items;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const WirdItemsHorizontalList({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return SizedBox(
      height: 52.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final isActive = index == activeIndex;
          final isCompleted = item.isCompleted;

          return InkWell(
            onTap: () => onSelect(index),
            borderRadius: BorderRadius.circular(20.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isActive
                    ? appColors.accentGold.withValues(alpha: 0.15)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isCompleted
                      ? appColors.statusSuccess
                      : (isActive ? appColors.accentGold : appColors.cardBorder),
                  width: isActive ? 1.4 : 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted) ...[
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14.sp,
                      color: appColors.statusSuccess,
                    ),
                    Gap(6.w),
                  ],
                  Text(
                    item.arabicText,
                    style: AppTypography.h5.copyWith(
                      fontSize: 13.sp,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: isCompleted
                          ? appColors.statusSuccess
                          : (isActive
                              ? appColors.accentGold
                              : theme.colorScheme.onSurface),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(8.w),
                  Text(
                    '${item.currentCount}/${item.targetCount}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
