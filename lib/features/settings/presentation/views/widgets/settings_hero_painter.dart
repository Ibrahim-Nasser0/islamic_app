import 'package:material_ui/material_ui.dart';

class SettingsHeroPainter extends CustomPainter {
  final Color goldColor;

  SettingsHeroPainter({required this.goldColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = goldColor.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const cornerLength = 16.0;
    const cornerRadius = 8.0;

    // Top-Left corner bracket
    final topLeft = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, cornerRadius)
      ..arcToPoint(const Offset(cornerRadius, 0),
          radius: const Radius.circular(cornerRadius))
      ..lineTo(cornerLength, 0);
    canvas.drawPath(topLeft, paint);

    // Top-Right corner bracket
    final topRight = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - cornerRadius, 0)
      ..arcToPoint(Offset(size.width, cornerRadius),
          radius: const Radius.circular(cornerRadius))
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(topRight, paint);

    // Bottom-Left corner bracket
    final bottomLeft = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - cornerRadius)
      ..arcToPoint(Offset(cornerRadius, size.height),
          radius: const Radius.circular(cornerRadius))
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(bottomLeft, paint);

    // Bottom-Right corner bracket
    final bottomRight = Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width - cornerRadius, size.height)
      ..arcToPoint(Offset(size.width, size.height - cornerRadius),
          radius: const Radius.circular(cornerRadius))
      ..lineTo(size.width, size.height - cornerLength);
    canvas.drawPath(bottomRight, paint);

    // Subtle arch crest in top center
    final centerX = size.width / 2;
    final archPath = Path()
      ..moveTo(centerX - 36, 0)
      ..quadraticBezierTo(centerX, 8, centerX + 36, 0);
    canvas.drawPath(archPath, paint);
  }

  @override
  bool shouldRepaint(covariant SettingsHeroPainter oldDelegate) =>
      oldDelegate.goldColor != goldColor;
}
