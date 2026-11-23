import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';

/// Quick actions bar for Qibla, Mosques, Azkar and Tasbeeh
class HomeQuickActionsBar extends StatelessWidget {
  const HomeQuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final actions = [
      {'title': 'qibla'.tr(), 'icon': FlutterIslamicIcons.solidQibla},
      {'title': 'mosques'.tr(), 'icon': FlutterIslamicIcons.locationMosque},
      {'title': 'azkar'.tr(), 'icon': FlutterIslamicIcons.prayer},
      {'title': 'tasbeeh'.tr(), 'icon': FlutterIslamicIcons.solidTasbih},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return InkWell(
          onTap: () => AppHaptics.light(),
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: 76.w,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: appColors.cardBorder, width: 0.8),
              boxShadow: appColors.cardShadow,
            ),
            child: Column(
              children: [
                Icon(
                  act['icon'] as IconData,
                  size: 24.sp,
                  color: theme.colorScheme.primary,
                ),
                Gap(6.h),
                Text(
                  act['title'] as String,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
