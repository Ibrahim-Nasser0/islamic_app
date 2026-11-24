import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

class SegmentedCircularProgressPainter extends CustomPainter {
  final int totalSegments;
  final int activeSegments;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  SegmentedCircularProgressPainter({
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

    double startAngle = -math.pi / 2 + (gapRadians / 2);

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
  bool shouldRepaint(covariant SegmentedCircularProgressPainter oldDelegate) {
    return oldDelegate.activeSegments != activeSegments ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
