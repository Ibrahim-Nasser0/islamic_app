import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';

/// Crisp vector-rendered Islamic Ayah end symbol with Arabic numeral perfectly centered
class AyahEndSymbol extends StatelessWidget {
  final int ayahNumber;
  final double fontSize;
  final VoidCallback? onTap;

  const AyahEndSymbol({
    super.key,
    required this.ayahNumber,
    required this.fontSize,
    this.onTap,
  });

  /// Converts standard integers into authentic Arabic numerals (١، ٢، ٣ ...)
  static String toArabicDigits(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isThreeDigits = ayahNumber >= 100;

    final symbolWidth = isThreeDigits ? (fontSize * 1.42).w : (fontSize * 1.25).w;
    final symbolHeight = (fontSize * 1.25).w;
    final numberFontSize = isThreeDigits ? (fontSize * 0.40).sp : (fontSize * 0.48).sp;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        width: symbolWidth,
        height: symbolHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ornamental Islamic Rosette / Medallion
            CustomPaint(
              size: Size(symbolWidth, symbolHeight),
              painter: _AyahOrnamentPainter(
                color: appColors.accentGold,
                isWide: isThreeDigits,
              ),
            ),

            // Perfectly Centered Arabic Number
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                toArabicDigits(ayahNumber),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: numberFontSize,
                  fontWeight: FontWeight.bold,
                  color: appColors.accentGold,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter that draws a gilded Islamic medallion with decorative finials
class _AyahOrnamentPainter extends CustomPainter {
  final Color color;
  final bool isWide;

  const _AyahOrnamentPainter({
    required this.color,
    required this.isWide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radiusX = (size.width / 2) - 2.5;
    final radiusY = (size.height / 2) - 2.5;

    // Fill paint
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    // Outer hairline stroke
    final outerStroke = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Inner subtle stroke
    final innerStroke = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final outerRect = Rect.fromCenter(
      center: center,
      width: radiusX * 2,
      height: radiusY * 2,
    );
    final innerRect = Rect.fromCenter(
      center: center,
      width: (radiusX - 2.2) * 2,
      height: (radiusY - 2.2) * 2,
    );

    // Draw background and concentric rings
    canvas.drawOval(outerRect, fillPaint);
    canvas.drawOval(outerRect, outerStroke);
    canvas.drawOval(innerRect, innerStroke);

    // Draw 4 decorative corner finials (diamonds)
    final finialPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final finialSize = 2.0;

    // Top
    _drawDiamond(canvas, Offset(center.dx, center.dy - radiusY - 0.5), finialSize, finialPaint);
    // Bottom
    _drawDiamond(canvas, Offset(center.dx, center.dy + radiusY + 0.5), finialSize, finialPaint);
    // Left
    _drawDiamond(canvas, Offset(center.dx - radiusX - 0.5, center.dy), finialSize, finialPaint);
    // Right
    _drawDiamond(canvas, Offset(center.dx + radiusX + 0.5, center.dy), finialSize, finialPaint);
  }

  void _drawDiamond(Canvas canvas, Offset p, double s, Paint paint) {
    final path = Path()
      ..moveTo(p.dx, p.dy - s)
      ..lineTo(p.dx + s, p.dy)
      ..lineTo(p.dx, p.dy + s)
      ..lineTo(p.dx - s, p.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AyahOrnamentPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isWide != isWide;
  }
}
