import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

/// Radiant celestial arc painter rotating smoothly around the loading spinner
class LoadingArcPainter extends CustomPainter {
  final double rotationAngle;
  final Color color;
  final Color trackColor;

  const LoadingArcPainter({
    required this.rotationAngle,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 2.5;

    // Track Circle
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, trackPaint);

    // Glowing Arc
    final arcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi * 2,
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.4),
          color,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(rotationAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      rotationAngle,
      math.pi * 1.35,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant LoadingArcPainter oldDelegate) =>
      oldDelegate.rotationAngle != rotationAngle ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}
