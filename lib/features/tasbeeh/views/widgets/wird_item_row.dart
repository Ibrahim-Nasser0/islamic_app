import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/custom_switcher_button.dart';
import '../../domain/entities/wird_item.dart';

/// Interactive Dhikr card in Wird customization sheet with inline quick target chips
class WirdItemRow extends StatelessWidget {
  final WirdItem item;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onTargetChanged;
  final VoidCallback? onDelete;

  static const List<int> _targetPresets = [33, 70, 100, 300, 1000];

  const WirdItemRow({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onTargetChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: item.isEnabled ? 1.0 : 0.55,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: item.isEnabled
                ? appColors.cardBorder
                : appColors.cardBorder.withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Title, Custom delete action & Switcher
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.arabicText,
                    style: AppTypography.h5.copyWith(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w600,
                      color: item.isEnabled
                          ? theme.colorScheme.onSurface
                          : appColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gap(8.w),
                if (onDelete != null) ...[
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 19.sp,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  Gap(8.w),
                ],
                CustomSwitcherButton(
                  value: item.isEnabled,
                  onChanged: onToggle,
                  activeColor: appColors.accentGold,
                ),
              ],
            ),

            // Row 2: Inline Target Selector Chips (when enabled)
            if (item.isEnabled) ...[
              Gap(10.h),
              Row(
                children: [
                  Text(
                    'الهدف:',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.textMuted,
                    ),
                  ),
                  Gap(6.w),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _targetPresets.map((preset) {
                          final isSelected = item.targetCount == preset;
                          return Padding(
                            padding: EdgeInsets.only(left: 6.w),
                            child: InkWell(
                              onTap: () {
                                AppHaptics.selection();
                                onTargetChanged(preset);
                              },
                              borderRadius: BorderRadius.circular(8.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? appColors.accentGold
                                      : appColors.badgeBackground,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? appColors.accentGold
                                        : appColors.cardBorder,
                                    width: isSelected ? 1.0 : 0.6,
                                  ),
                                ),
                                child: Text(
                                  '$preset',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.black
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
