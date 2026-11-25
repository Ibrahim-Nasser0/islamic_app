import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

/// Custom GPU painter rendering an astrolabe brass track, radial notches,
/// luminous sweep arc, and an orbiting prayer bead at the active progress head.
class TasbeehAstrolabePainter extends CustomPainter {
  final int totalTicks;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final Color beadCoreColor;

  const TasbeehAstrolabePainter({
    this.totalTicks = 33,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.beadCoreColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final trackRadius = outerRadius - 12.0;
    final clamped = progress.clamp(0.0, 1.0);

    // 1. Subtle outer hairline astrolabe ring
    canvas.drawCircle(
      center,
      trackRadius,
      Paint()
        ..color = inactiveColor.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5,
    );

    // 2. Radial precision notches around perimeter
    final activeTickPaint = Paint()
      ..color = activeColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final inactiveTickPaint = Paint()
      ..color = inactiveColor.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < totalTicks; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / totalTicks);
      final isMajor = i % 11 == 0;
      final tickLen = isMajor ? 7.0 : 4.0;
      final isActive = clamped > 0 && (i / totalTicks) <= clamped;
      final p1 = Offset(
        center.dx + (outerRadius - tickLen) * math.cos(angle),
        center.dy + (outerRadius - tickLen) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      canvas.drawLine(p1, p2, isActive ? activeTickPaint : inactiveTickPaint);
    }

    if (clamped <= 0) return;

    // 3. Swept luminous progress arc
    final rect = Rect.fromCircle(center: center, radius: trackRadius);
    final sweepAngle = 2 * math.pi * clamped;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5
        ..strokeCap = StrokeCap.round,
    );

    // 4. Orbiting sculpted prayer bead at head of arc
    final headAngle = -math.pi / 2 + sweepAngle;
    final beadCenter = Offset(
      center.dx + trackRadius * math.cos(headAngle),
      center.dy + trackRadius * math.sin(headAngle),
    );
    canvas.drawCircle(
      beadCenter,
      7.5,
      Paint()..color = activeColor.withValues(alpha: 0.24),
    );
    canvas.drawCircle(
      beadCenter,
      4.5,
      Paint()..color = beadCoreColor,
    );
  }

  @override
  bool shouldRepaint(covariant TasbeehAstrolabePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.inactiveColor != inactiveColor ||
      oldDelegate.beadCoreColor != beadCoreColor;
}
