import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../utils/extensions.dart';
import '../../utils/haptics.dart';
import '../islamic/octagonal_icon_frame.dart';
import 'morphing_nav_bar_item.dart';

/// Adaptive Celestial Sanctuary NavigationRail for medium and expanded viewports.
class SanctuaryNavRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;
  final bool extended;

  const SanctuaryNavRail({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: appColors.navCapsuleBg.withValues(alpha: 0.96),
        border: BorderDirectional(
          end: BorderSide(color: appColors.navCapsuleBorder, width: 1.0),
        ),
      ),
      child: SafeArea(
        right: false,
        left: false,
        child: NavigationRail(
          selectedIndex: currentIndex,
          extended: extended,
          minWidth: 78,
          minExtendedWidth: 196,
          backgroundColor: Colors.transparent,
          useIndicator: true,
          indicatorColor: appColors.navActivePillBg,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: appColors.accentGold.withValues(alpha: 0.42),
              width: 1.0,
            ),
          ),
          labelType:
              extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
          selectedIconTheme: IconThemeData(color: appColors.accentGold, size: 22),
          unselectedIconTheme: IconThemeData(color: appColors.textMuted, size: 22),
          selectedLabelTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: appColors.accentGold,
          ),
          unselectedLabelTextStyle: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: appColors.textMuted,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            child: OctagonalIconFrame(
              size: 36,
              active: true,
              child: Icon(
                items.first.activeIcon ?? items.first.icon,
                size: 16,
                color: appColors.accentGold,
              ),
            ),
          ),
          onDestinationSelected: (index) {
            AppHaptics.selection();
            onTap(index);
          },
          destinations: items.map((item) {
            return NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.activeIcon ?? item.icon),
              label: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
