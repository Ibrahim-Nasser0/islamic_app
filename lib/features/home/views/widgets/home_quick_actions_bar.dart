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

/// Quick actions bar for Qibla, Mosques, Azkar and Tasbeeh.
/// Adapts between a 4-column Row and a 2x2 Grid on narrow viewports or high text scale.
class HomeQuickActionsBar extends StatelessWidget {
  const HomeQuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    final actions = [
      ('qibla'.tr(), FlutterIslamicIcons.solidQibla, Routes.qibla),
      ('mosques'.tr(), FlutterIslamicIcons.locationMosque, Routes.mosques),
      ('azkar'.tr(), FlutterIslamicIcons.prayer, null),
      ('tasbeeh'.tr(), FlutterIslamicIcons.solidTasbih, Routes.tasbeeh),
    ];

    Widget buildCard(({String title, IconData icon, String? route}) act) {
      return _QuickActionCard(
        title: act.title,
        icon: act.icon,
        appColors: appColors,
        theme: theme,
        onTap: () {
          AppHaptics.light();
          if (act.route != null) {
            AppRouter.navigateTo(context, act.route!);
          }
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoByTwo = constraints.maxWidth < 310 || textScale >= 1.22;
        if (useTwoByTwo) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildCard((
                      title: actions[0].$1,
                      icon: actions[0].$2,
                      route: actions[0].$3,
                    )),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: buildCard((
                      title: actions[1].$1,
                      icon: actions[1].$2,
                      route: actions[1].$3,
                    )),
                  ),
                ],
              ),
              Gap(8.h),
              Row(
                children: [
                  Expanded(
                    child: buildCard((
                      title: actions[2].$1,
                      icon: actions[2].$2,
                      route: actions[2].$3,
                    )),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: buildCard((
                      title: actions[3].$1,
                      icon: actions[3].$2,
                      route: actions[3].$3,
                    )),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: actions.asMap().entries.map((entry) {
            final i = entry.key;
            final act = entry.value;

            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: i < actions.length - 1 ? 8.w : 0,
                ),
                child: buildCard((
                  title: act.$1,
                  icon: act.$2,
                  route: act.$3,
                )),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final AppThemeColors appColors;
  final ThemeData theme;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.appColors,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: widget.appColors.cardBorder, width: 0.9),
              boxShadow: widget.appColors.cardShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OctagonalIconFrame(
                  size: 38,
                  child: Icon(
                    widget.icon,
                    size: 18.sp,
                    color: widget.appColors.accentGold,
                  ),
                ),
                Gap(7.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
