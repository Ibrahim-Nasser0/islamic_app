import 'dart:math' as math;
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../utils/extensions.dart';
import '../../islamic/octagonal_icon_frame.dart';
import 'loading_arc_painter.dart';

/// Celestial Sanctuary spinner with rotating brass astrolabe arc and octagonal crest.
class LoadingBrandedSpinner extends StatefulWidget {
  final double? size;

  const LoadingBrandedSpinner({super.key, this.size});

  @override
  State<LoadingBrandedSpinner> createState() => _LoadingBrandedSpinnerState();
}

class _LoadingBrandedSpinnerState extends State<LoadingBrandedSpinner>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

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

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
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
    final appColors = context.appColors;
    final spinnerSize = widget.size ?? 78.r;

    return ScaleTransition(
      scale: _pulseAnimation,
      child: SizedBox(
        width: spinnerSize,
        height: spinnerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _rotationController,
              builder: (_, _) => CustomPaint(
                size: Size(spinnerSize, spinnerSize),
                painter: LoadingArcPainter(
                  rotationAngle: _rotationController.value * 2 * math.pi,
                  color: appColors.accentGold,
                  trackColor: appColors.cardBorder.withValues(alpha: 0.45),
                ),
              ),
            ),
            OctagonalIconFrame(
              size: 46,
              active: true,
              child: Icon(
                FlutterIslamicIcons.solidMosque,
                size: 20.sp,
                color: appColors.accentGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
