import 'package:islamic_app/core/utils/haptics.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            if (icon != null) ...[
              Icon(
                icon,
                color: iconColor ?? theme.colorScheme.primary,
                size: 22.sp,
              ),
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
                        color: theme.colorScheme.onSurface.withOpacity(0.55),
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

