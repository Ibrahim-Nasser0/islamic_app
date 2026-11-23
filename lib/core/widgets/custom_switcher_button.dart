import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/haptics.dart';

class CustomSwitcherButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData? activeIcon;
  final IconData? inactiveIcon;

  const CustomSwitcherButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeIcon = Icons.check_rounded,
    this.inactiveIcon = Icons.close_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onColor = activeColor ?? theme.colorScheme.primary;
    final offColor = inactiveColor ?? theme.colorScheme.outlineVariant;
    final inactiveIconColor = theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        onChanged(!value);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOutCubic,
        width: 50.w,
        height: 28.h,
        padding: EdgeInsets.all(2.5.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: value ? onColor : offColor,
          border: Border.all(
            color: value
                ? onColor.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: value
                  ? onColor.withValues(alpha: 0.25)
                  : Colors.transparent,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 23.w,
            height: 23.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              value ? activeIcon : inactiveIcon,
              size: 14.sp,
              color: value ? onColor : inactiveIconColor,
            ),
          ),
        ),
      ),
    );
  }
}
