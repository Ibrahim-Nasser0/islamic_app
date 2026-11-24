import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../utils/extensions.dart';
import '../utils/haptics.dart';
import 'custom_switcher_button.dart';

export 'custom_switcher_button.dart';

class CustomSwitcherTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final Color? iconColor;
  final Color? activeColor;
  final IconData? activeSwitchIcon;
  final IconData? inactiveSwitchIcon;
  final Widget? leading;
  final bool useIconBadge;

  const CustomSwitcherTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
    this.iconColor,
    this.activeColor,
    this.activeSwitchIcon = Icons.check_rounded,
    this.inactiveSwitchIcon = Icons.close_rounded,
    this.leading,
    this.useIconBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && icon != null) {
      if (useIconBadge) {
        leadingWidget = Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: appColors.badgeBackground,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: Icon(
            icon,
            color: iconColor ?? appColors.accentGold,
            size: 20.sp,
          ),
        );
      } else {
        leadingWidget = Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
          size: 22.sp,
        );
      }
    }

    return InkWell(
      onTap: () {
        AppHaptics.light();
        onChanged(!value);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            if (leadingWidget != null) ...[
              leadingWidget,
              Gap(14.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (subtitle != null) ...[
                    Gap(2.h),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.55),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            CustomSwitcherButton(
              value: value,
              activeColor: activeColor,
              activeIcon: activeSwitchIcon,
              inactiveIcon: inactiveSwitchIcon,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
