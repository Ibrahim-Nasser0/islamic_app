import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/tasbeeh_item.dart';

/// Horizontal scrollable selector for sacred authentic Azkar phrases
class TasbeehDhikrSelector extends StatelessWidget {
  final List<TasbeehItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const TasbeehDhikrSelector({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return SizedBox(
      height: 48.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final item = items[index];

          return InkWell(
            onTap: () => onSelect(index),
            borderRadius: BorderRadius.circular(24.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? appColors.accentGold.withValues(alpha: 0.15)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isSelected
                      ? appColors.accentGold
                      : appColors.cardBorder,
                  width: isSelected ? 1.4 : 0.8,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: appColors.accentGold.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : appColors.cardShadow,
              ),
              child: Center(
                child: Text(
                  item.arabicText,
                  style: AppTypography.h5.copyWith(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? appColors.accentGold
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
