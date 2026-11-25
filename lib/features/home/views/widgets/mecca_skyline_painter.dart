import 'package:material_ui/material_ui.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';

/// Vector CustomPainter depicting the Kaaba, Masjid Al-Haram arches & minarets,
/// Hijr Ismail arc, and celestial accents tailored to [DayAtmospherePhase].
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
    final bevelSilhouette = Paint()..color = const Color(0xFF142027);
    final midSilhouette = Paint()..color = const Color(0xFF111C22);
    final goldStroke = Paint()
      ..color = goldColor.withValues(alpha: 0.48)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final goldFill = Paint()..color = goldColor.withValues(alpha: 0.82);

    // 1. Atmospheric Sky Accents (Crescent + Stars OR Solar Halo)
    if (phase == DayAtmospherePhase.night || phase == DayAtmospherePhase.dawn) {
      final moonCenter = Offset(w * 0.76, h * 0.19);
      canvas.drawCircle(moonCenter, w * 0.055, Paint()..color = goldColor.withValues(alpha: 0.55));
      canvas.drawCircle(
        moonCenter.translate(w * 0.022, -h * 0.015),
        w * 0.05,
        Paint()..color = const Color(0xFF132228),
      );
      final starPaint = Paint()..color = goldColor.withValues(alpha: 0.7);
      canvas.drawCircle(Offset(w * 0.22, h * 0.18), 1.6, starPaint);
      canvas.drawCircle(Offset(w * 0.44, h * 0.10), 1.3, starPaint);
      canvas.drawCircle(Offset(w * 0.60, h * 0.24), 1.1, starPaint);
    } else {
      canvas.drawCircle(
        Offset(w * 0.74, h * 0.22),
        w * 0.20,
        Paint()..color = goldColor.withValues(alpha: 0.10),
      );
      canvas.drawCircle(
        Offset(w * 0.74, h * 0.22),
        w * 0.11,
        Paint()..color = goldColor.withValues(alpha: 0.14),
      );
    }

    // 2. Distant Masjid Al-Haram Arcade Arches, Dome & Twin Minarets
    for (var i = 0; i < 3; i++) {
      final cx = w * (0.17 + i * 0.09);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx, h * 0.90), width: w * 0.08, height: h * 0.20),
        3.14,
        3.14,
        true,
        midSilhouette,
      );
    }
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.78), width: w * 0.26, height: h * 0.28),
      3.14,
      3.14,
      true,
      midSilhouette,
    );
    _drawMinaret(canvas, Offset(w * 0.10, h), w * 0.065, h * 0.74, midSilhouette, goldFill);
    _drawMinaret(canvas, Offset(w * 0.88, h), w * 0.06, h * 0.66, midSilhouette, goldFill);

    // 3. Sacred Kaaba Monument with Subtle Bevel Shading & Hijr Ismail Arc
    final kaabaRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.34, h * 0.36, w * 0.44, h * 0.64),
      const Radius.circular(6),
    );
    canvas.drawRRect(kaabaRect, darkSilhouette);
    canvas.drawRect(Rect.fromLTWH(w * 0.34, h * 0.38, w * 0.13, h * 0.62), bevelSilhouette);
    canvas.drawRRect(kaabaRect, goldStroke);

    // Hijr Ismail Semi-Circular Curb
    canvas.drawArc(
      Rect.fromLTWH(w * 0.24, h * 0.86, w * 0.18, h * 0.20),
      3.14,
      3.14,
      false,
      goldStroke..strokeWidth = 1.4,
    );

    // Golden Kiswah Embroidery Band + Upper Trim
    canvas.drawRect(Rect.fromLTWH(w * 0.345, h * 0.48, w * 0.43, h * 0.055), goldFill);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.345, h * 0.445, w * 0.43, h * 0.015),
      Paint()..color = goldColor.withValues(alpha: 0.42),
    );

    // Door of the Kaaba (Al-Multazam)
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(w * 0.59, h * 0.67, w * 0.088, h * 0.33),
        topLeft: const Radius.circular(3.5),
        topRight: const Radius.circular(3.5),
      ),
      Paint()..color = goldColor.withValues(alpha: 0.72),
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
    canvas.drawRect(
      Rect.fromLTWH(baseCenter.dx - width * 0.72, top + height * 0.28, width * 1.44, 2.5),
      finialPaint,
    );
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
