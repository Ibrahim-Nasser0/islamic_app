import 'dart:math' as math;
import 'package:flutter/material.dart';

/// GPU-rendered radial bead ticks around the central Tasbeeh dial
class TasbeehTicksPainter extends CustomPainter {
  final int totalTicks;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  const TasbeehTicksPainter({
    this.totalTicks = 33,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < totalTicks; i++) {
      // Start from top (-pi / 2) clockwise
      final angle = -math.pi / 2 + (2 * math.pi * i / totalTicks);
      final isTickActive = (i / totalTicks) <= progress;

      // Outer and inner tick points
      final tickLength = (i % 11 == 0) ? 7.0 : 4.0;
      final outerX = center.dx + radius * math.cos(angle);
      final outerY = center.dy + radius * math.sin(angle);
      final innerX = center.dx + (radius - tickLength) * math.cos(angle);
      final innerY = center.dy + (radius - tickLength) * math.sin(angle);

      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        isTickActive ? activePaint : inactivePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TasbeehTicksPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
