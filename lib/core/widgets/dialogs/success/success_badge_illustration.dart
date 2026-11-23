import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'success_status_chip.dart';

/// Apple-grade frosted Emerald Squircle badge illustration for Success states
/// Features enlarged proportions (92r outer, 68r inner, 36sp icon),
/// living pulsating radial glow, and elastic spring checkmark animation.
class SuccessBadgeIllustration extends StatelessWidget {
  final Color accentColor;
  final List<Color> gradientColors;

  const SuccessBadgeIllustration({
    super.key,
    this.accentColor = const Color(0xFF10B981),
    this.gradientColors = const [Color(0xFF34D399), Color(0xFF059669)],
  });

  @override
  Widget build(BuildContext context) {
    final outerSize = 92.r;
    final orbitalSize = 82.r;
    final innerSize = 68.r;
    final iconSize = 36.sp;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: outerSize,
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Ambient pulsating emerald glow
              Container(
                width: outerSize,
                height: outerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.28),
                      accentColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1.15, 1.15),
                    duration: 2200.ms,
                    curve: Curves.easeInOut,
                  ),

              // 2. Concentric glass orbital ring
              Container(
                width: orbitalSize,
                height: orbitalSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.22),
                    width: 1.2,
                  ),
                ),
              ),

              // 3. Frosted Emerald Glass Squircle
              Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.25),
                      accentColor.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: iconSize,
                    color: accentColor,
                    shadows: [
                      Shadow(
                        color: accentColor.withValues(alpha: 0.40),
                        blurRadius: 10,
                      ),
                    ],
                  )
                      .animate()
                      .scale(
                        delay: 100.ms,
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                      ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 420.ms,
                    curve: Curves.easeOutBack,
                  ),
            ],
          ),
        ),
        Gap(8.h),

        // 4. Floating micro-status chip
        SuccessStatusChip(accentColor: accentColor),
      ],
    );
  }
}
