import 'package:material_ui/material_ui.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';

/// Vector CustomPainter depicting the Kaaba, Masjid Al-Haram minarets & dome,
/// and subtle celestial stars/halo tailored to the current [DayAtmospherePhase].
class MeccaSkylinePainter extends CustomPainter {
  final Color goldColor;
  final DayAtmospherePhase phase;

  const MeccaSkylinePainter({
    required this.goldColor,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final darkSilhouette = Paint()..color = const Color(0xFF0A1014);
    final midSilhouette = Paint()..color = const Color(0xFF10191F);
    final goldStroke = Paint()
      ..color = goldColor.withValues(alpha: 0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final goldFill = Paint()..color = goldColor.withValues(alpha: 0.78);

    // 1. Atmospheric Sky Accents (Stars or Warm Sun Halo)
    if (phase == DayAtmospherePhase.night || phase == DayAtmospherePhase.dawn) {
      final starPaint = Paint()..color = goldColor.withValues(alpha: 0.65);
      canvas.drawCircle(Offset(w * 0.22, h * 0.18), 1.6, starPaint);
      canvas.drawCircle(Offset(w * 0.44, h * 0.11), 1.2, starPaint);
      canvas.drawCircle(Offset(w * 0.78, h * 0.16), 1.5, starPaint);
    } else {
      canvas.drawCircle(
        Offset(w * 0.72, h * 0.24),
        w * 0.18,
        Paint()..color = goldColor.withValues(alpha: 0.12),
      );
    }

    // 2. Distant Dome & Twin Minarets
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.78), width: w * 0.26, height: h * 0.28),
      3.14,
      3.14,
      true,
      midSilhouette,
    );
    _drawMinaret(canvas, Offset(w * 0.10, h), w * 0.065, h * 0.74, midSilhouette, goldFill);
    _drawMinaret(canvas, Offset(w * 0.88, h), w * 0.06, h * 0.64, midSilhouette, goldFill);

    // 3. Sacred Kaaba Monument (Foreground Center-Right)
    final kaabaRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.34, h * 0.36, w * 0.44, h * 0.64),
      const Radius.circular(6),
    );
    canvas.drawRRect(kaabaRect, darkSilhouette);
    canvas.drawRRect(kaabaRect, goldStroke..color = goldColor.withValues(alpha: 0.35));

    // Golden Kiswah Embroidery Band
    canvas.drawRect(
      Rect.fromLTWH(w * 0.345, h * 0.48, w * 0.43, h * 0.055),
      goldFill,
    );

    // Subtle Door of the Kaaba (Al-Multazam)
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(w * 0.59, h * 0.68, w * 0.085, h * 0.32),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      ),
      Paint()..color = goldColor.withValues(alpha: 0.68),
    );
  }

  void _drawMinaret(
    Canvas canvas,
    Offset baseCenter,
    double width,
    double height,
    Paint bodyPaint,
    Paint finialPaint,
  ) {
    final top = baseCenter.dy - height;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(baseCenter.dx - width / 2, top + height * 0.16, width, height * 0.84),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      ),
      bodyPaint,
    );
    // Balcony ring
    canvas.drawRect(
      Rect.fromLTWH(baseCenter.dx - width * 0.72, top + height * 0.28, width * 1.44, 2.5),
      finialPaint,
    );
    // Conical spire
    final spire = Path()
      ..moveTo(baseCenter.dx - width * 0.42, top + height * 0.16)
      ..lineTo(baseCenter.dx, top)
      ..lineTo(baseCenter.dx + width * 0.42, top + height * 0.16)
      ..close();
    canvas.drawPath(spire, bodyPaint);
    canvas.drawCircle(Offset(baseCenter.dx, top), 1.8, finialPaint);
  }

  @override
  bool shouldRepaint(covariant MeccaSkylinePainter oldDelegate) =>
      oldDelegate.goldColor != goldColor || oldDelegate.phase != phase;
}
