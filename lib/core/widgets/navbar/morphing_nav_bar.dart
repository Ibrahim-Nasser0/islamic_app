import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../utils/constants.dart';
import '../../utils/extensions.dart';
import 'morphing_nav_bar_item.dart';

export 'morphing_nav_bar_item.dart';

/// A floating luxury navigation bar with morphing capsule pill indicators,
/// gesture scrubbing, and tactile haptic interactions for the Islamic App.
class MorphingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;

  const MorphingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  void _handleScrub({
    required Offset localPosition,
    required double totalWidth,
    required bool isRtl,
  }) {
    if (totalWidth <= 0 || items.isEmpty) return;
    final dx = localPosition.dx.clamp(0.0, totalWidth);
    final ratio = (dx / totalWidth).clamp(0.0, 0.999);
    final index = isRtl
        ? ((1.0 - ratio) * items.length).floor()
        : (ratio * items.length).floor();
    final clampedIndex = index.clamp(0, items.length - 1);
    if (clampedIndex != currentIndex) {
      onTap(clampedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isNarrow = screenWidth < 360;
    final isWide = screenWidth >= 600;
    final hPadding = isWide
        ? ((screenWidth - 460) / 2)
            .clamp(AppConstants.spacingLG.w, screenWidth * 0.3)
        : (isNarrow ? 12.w : AppConstants.spacingLG.w);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPadding,
              vertical: isNarrow ? 10.h : AppConstants.spacingMD.h,
            ),
            child: RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final totalWidth = constraints.maxWidth;

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragStart: (details) => _handleScrub(
                          localPosition: details.localPosition,
                          totalWidth: totalWidth,
                          isRtl: isRtl,
                        ),
                        onHorizontalDragUpdate: (details) => _handleScrub(
                          localPosition: details.localPosition,
                          totalWidth: totalWidth,
                          isRtl: isRtl,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingXS.w,
                            vertical: AppConstants.spacingSM.h,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.navCapsuleBg.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(40.r),
                            border: Border.all(
                              color: appColors.navCapsuleBorder,
                              width: 1.0,
                            ),
                            boxShadow: appColors.cardShadow,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(items.length, (i) {
                              return MorphingNavBarItem(
                                item: items[i],
                                isSelected: i == currentIndex,
                                onTap: () => onTap(i),
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
