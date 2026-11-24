import 'package:material_ui/material_ui.dart';

class AdhanAtmosphericBackground extends StatelessWidget {
  final String prayerKey;

  const AdhanAtmosphericBackground({
    super.key,
    required this.prayerKey,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getGradientColors(prayerKey);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(String key) {
    switch (key.toLowerCase()) {
      case 'fajr':
        return const [
          Color(0xFF0F2027),
          Color(0xFF203A43),
          Color(0xFF2C5364),
        ];
      case 'dhuhr':
        return const [
          Color(0xFF134E5E),
          Color(0xFF1E6B7B),
          Color(0xFF2E8B57),
        ];
      case 'asr':
        return const [
          Color(0xFF2C3E50),
          Color(0xFF34495E),
          Color(0xFF27AE60),
        ];
      case 'maghrib':
        return const [
          Color(0xFF232526),
          Color(0xFF414345),
          Color(0xFFB78628),
        ];
      case 'isha':
      default:
        return const [
          Color(0xFF0B131F),
          Color(0xFF142136),
          Color(0xFF1E3250),
        ];
    }
  }
}

