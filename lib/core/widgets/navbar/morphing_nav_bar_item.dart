import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../utils/extensions.dart';

/// Data class for a navigation tab item.
class NavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// An individual interactive navigation item with morphing pill animation,
/// tactile press feedback, and bidirectional (RTL/LTR) support.
class MorphingNavBarItem extends StatefulWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const MorphingNavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MorphingNavBarItem> createState() => _MorphingNavBarItemState();
}

class _MorphingNavBarItemState extends State<MorphingNavBarItem> {
  bool _isPressed = false;

  void _handleTapDown(_) => setState(() => _isPressed = true);
  void _handleTapUp(_) => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isNarrow = MediaQuery.sizeOf(context).width < 360;

    final activePillBg = appColors.navActivePillBg;
    final activeColor = appColors.accentGold;
    final inactiveColor = appColors.textMuted;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: widget.isSelected
                ? (isNarrow ? 10.w : 14.w)
                : (isNarrow ? 7.w : 10.w),
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected ? activePillBg : Colors.transparent,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: widget.isSelected
                  ? appColors.accentGold.withValues(alpha: 0.42)
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: widget.isSelected ? 1.10 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Icon(
                  widget.isSelected
                      ? (widget.item.activeIcon ?? widget.item.icon)
                      : widget.item.icon,
                  color: widget.isSelected ? activeColor : inactiveColor,
                  size: isNarrow ? 20.sp : 22.sp,
                ),
              ),
              ClipRect(
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: widget.isSelected ? 1.0 : 0.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    opacity: widget.isSelected ? 1.0 : 0.0,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: isNarrow ? 4.w : 6.w,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isNarrow ? 78 : 110,
                        ),
                        child: Text(
                          widget.item.label,
                          style: TextStyle(
                            fontSize: isNarrow ? 11.5.sp : 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: activeColor,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
