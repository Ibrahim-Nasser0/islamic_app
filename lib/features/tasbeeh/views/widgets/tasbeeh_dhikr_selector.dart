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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = index == selectedIndex;
          final item = items[index];

          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: index < items.length - 1 ? 8.w : 0,
            ),
            child: InkWell(
              onTap: () => onSelect(index),
              borderRadius: BorderRadius.circular(24.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? appColors.accentGold.withValues(alpha: 0.15)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isSelected
                        ? appColors.accentGold
                        : appColors.cardBorder,
                    width: isSelected ? 1.3 : 0.8,
                  ),
                  boxShadow: appColors.cardShadow,
                ),
                child: Text(
                  item.arabicText,
                  maxLines: 1,
                  style: AppTypography.h5.copyWith(
                    fontSize: 13.5.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? appColors.accentGold
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
