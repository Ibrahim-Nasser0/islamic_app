import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'failure_status_chip.dart';
import 'failure_ui_config.dart';

/// Refined frosted glassmorphism badge illustration for failure states
/// Features enlarged proportions, ambient pulsating halo, spring entrance,
/// and subtle error-shake micro-animation.
class FailureBadgeIllustration extends StatelessWidget {
  final FailureUIConfig config;
  final bool isCompact;

  const FailureBadgeIllustration({
    super.key,
    required this.config,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    final outerSize = isCompact ? 92.r : 124.r;
    final orbitalSize = isCompact ? 82.r : 106.r;
    final innerSize = isCompact ? 68.r : 88.r;
    final iconSize = isCompact ? 36.sp : 46.sp;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: outerSize,
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Ambient pulsating glow
              Container(
                width: outerSize,
                height: outerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      config.accentColor.withValues(alpha: 0.28),
                      config.accentColor.withValues(alpha: 0.0),
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
                    color: config.accentColor.withValues(alpha: 0.22),
                    width: 1.2,
                  ),
                ),
              ),

              // 3. Frosted Glass Squircle
              Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isCompact ? 22.r : 28.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      config.accentColor.withValues(alpha: 0.25),
                      config.accentColor.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: config.accentColor.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: config.accentColor.withValues(alpha: 0.25),
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
                    config.icon,
                    size: iconSize,
                    color: config.accentColor,
                    shadows: [
                      Shadow(
                        color: config.accentColor.withValues(alpha: 0.40),
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
                        duration: 500.ms,
                        hz: 2.5,
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
        ),
        Gap(isCompact ? 8.h : 12.h),

        // 4. Floating micro-status chip
        FailureStatusChip(
          label: config.statusTagKey.tr(),
          accentColor: config.accentColor,
          isCompact: isCompact,
        ),
      ],
    );
  }
}
