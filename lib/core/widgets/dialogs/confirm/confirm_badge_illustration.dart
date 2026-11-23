import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Apple/Stripe-grade animated squircle badge illustration for confirmation states.
/// Features ambient breathing radial glow, concentric glass orbital ring,
/// spring scale-in, and tactile micro-attention animation.
class ConfirmBadgeIllustration extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  const ConfirmBadgeIllustration({
    super.key,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final outerSize = 92.r;
    final orbitalSize = 82.r;
    final innerSize = 68.r;
    final iconSize = 36.sp;

    final isWarning = icon == Icons.warning_amber_rounded ||
        icon == Icons.visibility_off_rounded ||
        icon == Icons.error_outline_rounded;

    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Ambient pulsating radial halo
          Container(
            width: outerSize,
            height: outerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  iconColor.withValues(alpha: 0.28),
                  iconColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
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
                color: iconColor.withValues(alpha: 0.22),
                width: 1.2,
              ),
            ),
          ),

          // 3. Frosted Squircle Vessel with Apple curvature
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  iconColor.withValues(alpha: 0.25),
                  iconColor.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.45),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.25),
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
                icon,
                size: iconSize,
                color: iconColor,
                shadows: [
                  Shadow(
                    color: iconColor.withValues(alpha: 0.40),
                    blurRadius: 10,
                  ),
                ],
              )
                  .animate()
                  .scale(
                    delay: 80.ms,
                    duration: 380.ms,
                    curve: Curves.easeOutBack,
                  )
                  .then()
                  .shake(
                    duration: isWarning ? 500.ms : 0.ms,
                    hz: 2,
                    curve: Curves.easeInOut,
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
    );
  }
}
