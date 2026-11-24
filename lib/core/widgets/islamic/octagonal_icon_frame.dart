import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import '../../utils/extensions.dart';

/// Octagonal double-diamond emblem crest mirroring the Celestial Sanctuary brand.
class OctagonalIconFrame extends StatelessWidget {
  final Widget child;
  final double size;
  final bool active;

  const OctagonalIconFrame({
    super.key,
    required this.child,
    this.size = 44,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final s = size.w;
    final inner = (size * 0.82).w;

    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: inner,
              height: inner,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((size * 0.2).r),
                color: active
                    ? appColors.emeraldBevelTop.withValues(alpha: 0.16)
                    : appColors.surfaceSubtle,
                border: Border.all(
                  color: appColors.accentGold.withValues(
                    alpha: active ? 0.55 : 0.25,
                  ),
                  width: 0.9,
                ),
              ),
            ),
          ),
          Container(
            width: inner,
            height: inner,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((size * 0.24).r),
              gradient: active
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        appColors.emeraldBevelTop,
                        appColors.emeraldBevelBottom,
                      ],
                    )
                  : null,
              color: active ? null : appColors.navCapsuleBg,
              border: Border.all(
                color: appColors.accentGold.withValues(
                  alpha: active ? 0.6 : 0.28,
                ),
                width: 0.9,
              ),
            ),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
