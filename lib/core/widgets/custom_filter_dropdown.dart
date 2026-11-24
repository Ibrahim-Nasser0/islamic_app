import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../utils/extensions.dart';
import '../utils/haptics.dart';

class CustomFilterDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const CustomFilterDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class CustomFilterDropdown<T> extends StatefulWidget {
  final T selectedValue;
  final List<CustomFilterDropdownItem<T>> items;
  final ValueChanged<T> onSelected;
  final Widget? trigger;

  const CustomFilterDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onSelected,
    this.trigger,
  });

  @override
  State<CustomFilterDropdown<T>> createState() =>
      _CustomFilterDropdownState<T>();
}

class _CustomFilterDropdownState<T> extends State<CustomFilterDropdown<T>> {
  final GlobalKey _triggerKey = GlobalKey();

  void _openMenu() {
    AppHaptics.light();
    final renderBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height + 4.h,
      offset.dx + size.width,
      offset.dy + size.height + 4.h,
    );

    showMenu<T>(
      context: context,
      position: position,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(color: appColors.cardBorder, width: 0.8),
      ),
      color: theme.colorScheme.surface,
      constraints: const BoxConstraints(minWidth: 0),
      items: widget.items.map((item) {
        final isSelected = item.value == widget.selectedValue;
        return PopupMenuItem<T>(
          value: item.value,
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 15.sp,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  Gap(8.w),
                ],
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ).then((val) {
      if (val != null && val != widget.selectedValue) {
        AppHaptics.selection();
        widget.onSelected(val);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.trigger != null) {
      return GestureDetector(
        key: _triggerKey,
        onTap: _openMenu,
        child: widget.trigger!,
      );
    }

    final appColors = context.appColors;
    final currentItem = widget.items.firstWhere(
      (it) => it.value == widget.selectedValue,
      orElse: () => widget.items.first,
    );

    return InkWell(
      key: _triggerKey,
      onTap: _openMenu,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: appColors.accentGold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: appColors.accentGold.withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentItem.label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: appColors.accentGold,
              ),
            ),
            Gap(4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.sp,
              color: appColors.accentGold,
            ),
          ],
        ),
      ),
    );
  }
}
