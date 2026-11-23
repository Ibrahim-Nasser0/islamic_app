import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:material_ui/material_ui.dart';

class OnBoardingCircularNextButton extends StatelessWidget {
  final PageController pageController;
  final int totalPages;

  const OnBoardingCircularNextButton({
    super.key,
    required this.pageController,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final currentPage = pageController.hasClients
        ? (pageController.page?.round() ?? 0)
        : 0;

    final isLastPage = currentPage == totalPages - 1;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final IconData centerIcon = isLastPage
        ? Icons.check_rounded
        : (isRtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded);

    return GestureDetector(
      onTap: () {
        AppHaptics.medium();
        if (!isLastPage) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          );
        } else {
          AppRouter.navigateAndReplace(context, Routes.home);
        }
      },
      child: SizedBox(
        width: 72.w,
        height: 72.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(72.w, 72.w),
              painter: _SegmentedCircularProgressPainter(
                totalSegments: totalPages,
                activeSegments: currentPage + 1,
                activeColor: appColors.accentGold,
                inactiveColor: theme.colorScheme.primary.withValues(alpha: 0.18),
                strokeWidth: 3.5.w,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 54.w,
              height: 54.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: child,
                ),
                child: Icon(
                  centerIcon,
                  key: ValueKey<IconData>(centerIcon),
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ).buttonAnimation(),
          ],
        ),
      ),
    );
  }
}

class _SegmentedCircularProgressPainter extends CustomPainter {
  final int totalSegments;
  final int activeSegments;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  _SegmentedCircularProgressPainter({
    required this.totalSegments,
    required this.activeSegments,
    required this.activeColor,
    required this.inactiveColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const gapDegrees = 14.0;
    final gapRadians = gapDegrees * (math.pi / 180);
    final totalGapRadians = gapRadians * totalSegments;
    final totalArcRadians = (2 * math.pi) - totalGapRadians;
    final segmentArcRadians = totalArcRadians / totalSegments;

    double startAngle = -math.pi / 2;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < totalSegments; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentArcRadians,
        false,
        inactivePaint,
      );

      if (i < activeSegments) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          segmentArcRadians,
          false,
          activePaint,
        );
      }

      startAngle += segmentArcRadians + gapRadians;
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedCircularProgressPainter oldDelegate) {
    return oldDelegate.activeSegments != activeSegments ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
