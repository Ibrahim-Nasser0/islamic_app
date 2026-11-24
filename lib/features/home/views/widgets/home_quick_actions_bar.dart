import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';

/// Quick actions bar for Qibla, Mosques, Azkar and Tasbeeh
class HomeQuickActionsBar extends StatelessWidget {
  const HomeQuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final actions = [
      {
        'title': 'qibla'.tr(),
        'icon': FlutterIslamicIcons.solidQibla,
        'route': Routes.qibla,
      },
      {
        'title': 'mosques'.tr(),
        'icon': FlutterIslamicIcons.locationMosque,
        'route': Routes.mosques,
      },
      {
        'title': 'azkar'.tr(),
        'icon': FlutterIslamicIcons.prayer,
        'route': null,
      },
      {
        'title': 'tasbeeh'.tr(),
        'icon': FlutterIslamicIcons.solidTasbih,
        'route': Routes.tasbeeh,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        final route = act['route'] as String?;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              AppHaptics.light();
              if (route != null) {
                AppRouter.navigateTo(context, route);
              }
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 78.w,
              padding: EdgeInsets.symmetric(vertical: 11.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: appColors.cardBorder, width: 0.9),
                boxShadow: appColors.cardShadow,
              ),
              child: Column(
                children: [
                  OctagonalIconFrame(
                    size: 38,
                    child: Icon(
                      act['icon'] as IconData,
                      size: 18.sp,
                      color: appColors.accentGold,
                    ),
                  ),
                  Gap(7.h),
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
          ),
        );
      }).toList(),
    );
  }
}
