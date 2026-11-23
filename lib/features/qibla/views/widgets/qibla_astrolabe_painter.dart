import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

/// GPU-rendered Islamic Astrolabe Dial Painter with accurate astronomical degree marks
class QiblaAstrolabePainter extends CustomPainter {
  final Color primaryColor;
  final Color accentGold;
  final Color tickColor;
  final Color cardinalColor;
  final bool isAligned;

  const QiblaAstrolabePainter({
    required this.primaryColor,
    required this.accentGold,
    required this.tickColor,
    required this.cardinalColor,
    required this.isAligned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Concentric Astrolabe Rings
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = isAligned
          ? accentGold.withValues(alpha: 0.6)
          : tickColor.withValues(alpha: 0.25);

    canvas.drawCircle(center, radius - 2, ringPaint);
    canvas.drawCircle(center, radius - 18, ringPaint..strokeWidth = 0.8);
    canvas.drawCircle(center, radius - 48, ringPaint..strokeWidth = 0.6);

    // 2. Graduation Ticks (Every 5 degrees = 72 ticks)
    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 360; i += 5) {
      final double rad = (i - 90) * (math.pi / 180.0);
      final bool isMajor = (i % 30 == 0);
      final bool isMedium = (i % 15 == 0 && !isMajor);
      final double tickLength = isMajor ? 12.0 : (isMedium ? 7.5 : 4.5);

      tickPaint.strokeWidth = isMajor ? 1.8 : (isMedium ? 1.2 : 0.8);
      tickPaint.color = isMajor
          ? (i == 0
              ? Colors.redAccent
              : (isAligned ? accentGold : tickColor.withValues(alpha: 0.8)))
          : tickColor.withValues(alpha: 0.35);

      final outerR = radius - 4;
      final innerR = outerR - tickLength;

      final p1 = Offset(center.dx + outerR * math.cos(rad), center.dy + outerR * math.sin(rad));
      final p2 = Offset(center.dx + innerR * math.cos(rad), center.dy + innerR * math.sin(rad));

      canvas.drawLine(p1, p2, tickPaint);
    }

    // 3. Cardinal Direction Indicators (N, E, S, W)
    final cardinals = [
      (0, 'N', Colors.redAccent),
      (90, 'E', cardinalColor),
      (180, 'S', cardinalColor),
      (270, 'W', cardinalColor),
    ];

    for (final c in cardinals) {
      final double rad = (c.$1 - 90) * (math.pi / 180.0);
      final double textR = radius - 32;
      final pos = Offset(center.dx + textR * math.cos(rad), center.dy + textR * math.sin(rad));

      final textSpan = TextSpan(
        text: c.$2,
        style: TextStyle(
          color: c.$3,
          fontSize: c.$1 == 0 ? 14 : 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
    }

    // 4. Eight Sacred Octagram Marks at 45 degree diagonals
    final starPaint = Paint()
      ..color = (isAligned ? accentGold : tickColor).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (int deg = 45; deg < 360; deg += 90) {
      final double rad = (deg - 90) * (math.pi / 180.0);
      final double dotR = radius - 32;
      final dotPos = Offset(center.dx + dotR * math.cos(rad), center.dy + dotR * math.sin(rad));
      canvas.drawCircle(dotPos, 2.2, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant QiblaAstrolabePainter oldDelegate) {
    return oldDelegate.isAligned != isAligned ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentGold != accentGold;
  }
}
