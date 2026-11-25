import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../utils/extensions.dart';
import '../../islamic/rub_el_hizb_mark.dart';

/// Unified geometric octagonal seal for Celestial Sanctuary modal states.
class SanctuaryDialogBadge extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String? statusLabel;
  final bool useEmeraldBevel;
  final bool subtleShake;

  const SanctuaryDialogBadge({
    super.key,
    required this.icon,
    required this.accentColor,
    this.statusLabel,
    this.useEmeraldBevel = false,
    this.subtleShake = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final outerSize = 84.r;
    final innerSize = 62.r;

    final baseAnim = Icon(
      icon,
      size: 30.sp,
      color: useEmeraldBevel ? appColors.accentGold : accentColor,
    )
        .animate()
        .scale(delay: 80.ms, duration: 360.ms, curve: Curves.easeOutBack);

    final Widget iconWidget = subtleShake
        ? baseAnim.then().shake(duration: 420.ms, hz: 2, curve: Curves.easeInOut)
        : baseAnim;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: outerSize,
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: outerSize,
                height: outerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.24),
                    width: 1.0,
                  ),
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.14),
                      accentColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: useEmeraldBevel
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            appColors.emeraldBevelTop,
                            appColors.emeraldBevelBottom,
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withValues(alpha: 0.18),
                            accentColor.withValues(alpha: 0.06),
                          ],
                        ),
                  border: Border.all(
                    color: (useEmeraldBevel ? appColors.accentGold : accentColor)
                        .withValues(alpha: 0.48),
                    width: 1.1,
                  ),
                ),
                child: Center(child: iconWidget),
              ).animate().scale(
                    begin: const Offset(0.7, 0.7),
                    end: const Offset(1.0, 1.0),
                    duration: 340.ms,
                    curve: Curves.easeOutBack,
                  ),
            ],
          ),
        ),
        if (statusLabel != null) ...[
          Gap(8.h),
          SanctuaryDialogChip(
            label: statusLabel!,
            accentColor: accentColor,
          ),
        ],
      ],
    );
  }
}

/// Crisp semantic status chip anchored with Rub el-Hizb emblem.
class SanctuaryDialogChip extends StatelessWidget {
  final String label;
  final Color accentColor;

  const SanctuaryDialogChip({
    super.key,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.30),
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RubElHizbMark(size: 8.w, color: accentColor),
          Gap(5.w),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: accentColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
          ),
        ],
      ),
    );
  }
}
