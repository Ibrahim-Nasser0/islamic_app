import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:material_ui/material_ui.dart';



class SettingsIconBadge extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;

  const SettingsIconBadge({
    super.key,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final badgeSize = size ?? 40.w;

    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? appColors.badgeBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Icon(
        icon,
        size: 20.sp,
        color: iconColor ?? appColors.accentGold,
      ),
    );
  }
}
