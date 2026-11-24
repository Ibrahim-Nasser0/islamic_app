import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

/// Vector painter rendering the classic 8-pointed Rub el-Hizb Islamic star.
class RubElHizbMark extends StatelessWidget {
  final double size;
  final Color color;

  const RubElHizbMark({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _RubElHizbPainter(color: color),
    );
  }
}

class _RubElHizbPainter extends CustomPainter {
  final Color color;
  const _RubElHizbPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final side = size.width * 0.58;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.width * 0.085).clamp(0.9, 1.8);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: side, height: side),
        Radius.circular(size.width * 0.06),
      ),
      stroke,
    );
    canvas.rotate(math.pi / 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: side, height: side),
        Radius.circular(size.width * 0.06),
      ),
      stroke,
    );
    canvas.restore();

    canvas.drawCircle(
      center,
      (size.width * 0.1).clamp(1.2, 2.8),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _RubElHizbPainter oldDelegate) =>
      oldDelegate.color != color;
}
