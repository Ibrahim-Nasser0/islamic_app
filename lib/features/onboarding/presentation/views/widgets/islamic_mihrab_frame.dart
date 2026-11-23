import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:material_ui/material_ui.dart';



/// An architectural Islamic Mihrab (محراب) horseshoe arch frame
class IslamicMihrabFrame extends StatelessWidget {
  final Widget child;
  final double size;

  const IslamicMihrabFrame({
    super.key,
    required this.child,
    this.size = 210,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return SizedBox(
      width: size.w,
      height: (size * 1.15).w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient aura
          Container(
            width: size.w * 0.9,
            height: size.w * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: appColors.accentGold.withValues(alpha: 0.08),
                  blurRadius: 60,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // Procedural Mihrab Arch CustomPaint
          CustomPaint(
            size: Size(size.w, (size * 1.15).w),
            painter: _MihrabArchPainter(
              surfaceColor: theme.colorScheme.surface,
              borderColor: appColors.accentGold.withValues(alpha: 0.45),
              innerGlowColor: theme.colorScheme.primary.withValues(alpha: 0.06),
            ),
          ),
          // Inner content
          Positioned(
            top: (size * 0.22).w,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _MihrabArchPainter extends CustomPainter {
  final Color surfaceColor;
  final Color borderColor;
  final Color innerGlowColor;

  _MihrabArchPainter({
    required this.surfaceColor,
    required this.borderColor,
    required this.innerGlowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Start at bottom left
    path.moveTo(w * 0.12, h * 0.95);
    // Left vertical pillar
    path.lineTo(w * 0.12, h * 0.45);
    // Ogee / Horseshoe arch curvature to peak
    path.cubicTo(w * 0.12, h * 0.25, w * 0.35, h * 0.12, w * 0.5, h * 0.04);
    // Symmetrical right curve down
    path.cubicTo(w * 0.65, h * 0.12, w * 0.88, h * 0.25, w * 0.88, h * 0.45);
    // Right vertical pillar
    path.lineTo(w * 0.88, h * 0.95);
    // Bottom curved base
    path.quadraticBezierTo(w * 0.5, h * 0.98, w * 0.12, h * 0.95);
    path.close();

    // Fill surface
    final fillPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Inner Glow
    final glowPaint = Paint()
      ..color = innerGlowColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, glowPaint);

    // Outer Hairline Border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, borderPaint);

    // Decorative inner finial bead at the arch apex
    final apexPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.04), 3.0, apexPaint);
  }

  @override
  bool shouldRepaint(covariant _MihrabArchPainter oldDelegate) {
    return oldDelegate.surfaceColor != surfaceColor ||
        oldDelegate.borderColor != borderColor;
  }
}
