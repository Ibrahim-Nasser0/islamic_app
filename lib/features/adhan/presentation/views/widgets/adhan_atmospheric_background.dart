import 'dart:math' as math;
import 'package:flutter/material.dart';

class AdhanAtmosphericBackground extends StatelessWidget {
  final String prayerKey;

  const AdhanAtmosphericBackground({
    super.key,
    required this.prayerKey,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getGradientColors(prayerKey);
    final accentGlow = _getAccentGlow(prayerKey);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Base Celestial Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
              stops: const [0.0, 0.35, 0.7, 1.0],
            ),
          ),
        ),

        // 2. Heavenly Zenith Radial Light
        Positioned(
          top: -100,
          left: 0,
          right: 0,
          height: 380,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.1,
                colors: [
                  accentGlow.withValues(alpha: 0.22),
                  accentGlow.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 3. Ambient Islamic Geometric Watermark
        Positioned.fill(
          child: CustomPaint(
            painter: _IslamicGeometricPatternPainter(
              color: Colors.white.withValues(alpha: 0.025),
            ),
          ),
        ),

        // 4. Subtle Ambient Floating Dust / Stars
        Positioned(
          bottom: -60,
          right: -40,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentGlow.withValues(alpha: 0.06),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors(String key) {
    switch (key.toLowerCase()) {
      case 'fajr':
        return const [
          Color(0xFF07141A),
          Color(0xFF0D2530),
          Color(0xFF143B4A),
          Color(0xFF1F5466),
        ];
      case 'dhuhr':
        return const [
          Color(0xFF07201B),
          Color(0xFF0E3830),
          Color(0xFF145246),
          Color(0xFF1B6C5C),
        ];
      case 'asr':
        return const [
          Color(0xFF0D1B18),
          Color(0xFF16322C),
          Color(0xFF1E463E),
          Color(0xFF285C51),
        ];
      case 'maghrib':
        return const [
          Color(0xFF1F1009),
          Color(0xFF331B10),
          Color(0xFF4A2718),
          Color(0xFF6B3822),
        ];
      case 'isha':
      default:
        return const [
          Color(0xFF050B14),
          Color(0xFF0B172A),
          Color(0xFF11233E),
          Color(0xFF193257),
        ];
    }
  }

  Color _getAccentGlow(String key) {
    switch (key.toLowerCase()) {
      case 'fajr':
        return const Color(0xFF64B5F6);
      case 'dhuhr':
        return const Color(0xFF4DB6AC);
      case 'asr':
        return const Color(0xFF81C784);
      case 'maghrib':
        return const Color(0xFFFFB74D);
      case 'isha':
      default:
        return const Color(0xFF7986CB);
    }
  }
}

class _IslamicGeometricPatternPainter extends CustomPainter {
  final Color color;

  _IslamicGeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height * 0.45);
    final maxRadius = size.width * 0.65;

    // Draw concentric sacred geometry circles and 8-point rosettes
    for (double r = 40; r <= maxRadius; r += 55) {
      canvas.drawCircle(center, r, paint);
    }

    // Radial spokes (8 directions)
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final dx = center.dx + maxRadius * math.cos(angle);
      final dy = center.dy + maxRadius * math.sin(angle);
      canvas.drawLine(center, Offset(dx, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IslamicGeometricPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
