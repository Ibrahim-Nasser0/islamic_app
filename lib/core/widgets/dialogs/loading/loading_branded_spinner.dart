import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'loading_arc_painter.dart';

/// Kinetic Mot7km Branded Spinner with continuous celestial rotation,
/// breathing pulse, and luminous ambient glow.
class LoadingBrandedSpinner extends StatefulWidget {
  final double? size;

  const LoadingBrandedSpinner({super.key, this.size});

  @override
  State<LoadingBrandedSpinner> createState() => _LoadingBrandedSpinnerState();
}

class _LoadingBrandedSpinnerState extends State<LoadingBrandedSpinner>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final spinnerSize = widget.size ?? 80.r;

    return ScaleTransition(
      scale: _pulseAnimation,
      child: SizedBox(
        width: spinnerSize,
        height: spinnerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Ambient pulsating glow
            Container(
              width: spinnerSize,
              height: spinnerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.28),
                    blurRadius: 22.r,
                    spreadRadius: 2.r,
                  ),
                ],
              ),
            ),

            // 2. Radiant celestial arc
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, _) => CustomPaint(
                size: Size(spinnerSize, spinnerSize),
                painter: LoadingArcPainter(
                  rotationAngle: _rotationController.value * 2 * math.pi,
                  color: primary,
                  trackColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
            ),

            // 3. Central rotating Mot7km Logo
            Padding(
              padding: EdgeInsets.all(16.r),
              child: RotationTransition(
                turns: _rotationController,
                child: Image.asset(
                  'assets/images/Mot7km_Logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
