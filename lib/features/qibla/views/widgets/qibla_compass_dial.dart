import 'dart:math' as math;
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/qibla_data.dart';
import 'qibla_astrolabe_painter.dart';

/// Luxury Islamic Astrolabe Qibla Compass with smooth angular damping and breathing pulse
class QiblaCompassDial extends StatefulWidget {
  final QiblaData data;

  const QiblaCompassDial({super.key, required this.data});

  @override
  State<QiblaCompassDial> createState() => _QiblaCompassDialState();
}

class _QiblaCompassDialState extends State<QiblaCompassDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.data.isAligned) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant QiblaCompassDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.isAligned && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.data.isAligned && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isAligned = widget.data.isAligned;

    final targetDialAngle = -widget.data.deviceHeading * (math.pi / 180.0);
    final targetNeedleAngle = widget.data.offset * (math.pi / 180.0);

    return SizedBox(
      width: 300.w,
      height: 300.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Ambient Breathing Halo when aligned
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 295.w * (isAligned ? _pulseAnimation.value : 1.0),
                height: 295.w * (isAligned ? _pulseAnimation.value : 1.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAligned
                      ? appColors.statusSuccess.withValues(alpha: 0.07)
                      : Colors.transparent,
                  border: Border.all(
                    color: isAligned
                        ? appColors.statusSuccess.withValues(alpha: 0.4)
                        : Colors.transparent,
                    width: 1.2,
                  ),
                ),
              );
            },
          ),

          // 2. Astrolabe Rim Background
          Container(
            width: 290.w,
            height: 290.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
              boxShadow: isAligned
                  ? [
                      BoxShadow(
                        color: appColors.statusSuccess.withValues(alpha: 0.22),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ]
                  : appColors.cardShadow,
            ),
          ),

          // 3. Rotating GPU-Rendered Astrolabe Dial (Cardinal Marks & Degree Ticks)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: targetDialAngle),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: angle,
                child: CustomPaint(
                  size: Size(290.w, 290.w),
                  painter: QiblaAstrolabePainter(
                    primaryColor: theme.colorScheme.primary,
                    accentGold: appColors.accentGold,
                    tickColor: appColors.textMuted,
                    cardinalColor: theme.colorScheme.onSurface,
                    isAligned: isAligned,
                  ),
                ),
              );
            },
          ),

          // 4. Smooth Kaaba Direction Needle
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: targetNeedleAngle),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: angle,
                child: _buildPrecisionNeedle(appColors, isAligned),
              );
            },
          ),

          // 5. Center Sacred Kaaba Jewel
          _buildCenterKaabaJewel(theme, appColors, isAligned),
        ],
      ),
    );
  }

  Widget _buildPrecisionNeedle(dynamic appColors, bool isAligned) {
    final activeColor = isAligned ? appColors.statusSuccess : appColors.accentGold;

    return SizedBox(
      width: 290.w,
      height: 290.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top Arrowhead pointing to Kaaba
          Positioned(
            top: 22.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.navigation_rounded,
                  size: 26.sp,
                  color: activeColor,
                ),
                Container(
                  width: 3.5.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2.r),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Counter-weight indicator
          Positioned(
            bottom: 30.h,
            child: Container(
              width: 8.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: appColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterKaabaJewel(ThemeData theme, dynamic appColors, bool isAligned) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 72.w,
      height: 72.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: isAligned ? appColors.statusSuccess : appColors.accentGold,
          width: isAligned ? 2.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isAligned ? appColors.statusSuccess : appColors.accentGold)
                .withValues(alpha: isAligned ? 0.35 : 0.15),
            blurRadius: 14,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          FlutterIslamicIcons.solidKaaba,
          size: 30.sp,
          color: isAligned ? appColors.statusSuccess : appColors.accentGold,
        ),
      ),
    );
  }
}
