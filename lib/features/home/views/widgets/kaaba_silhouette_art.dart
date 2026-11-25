import 'package:material_ui/material_ui.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';
import 'mecca_skyline_painter.dart';

/// Adaptive vector skyline artwork for the Kaaba and Masjid Al-Haram horizon.
class KaabaSilhouetteArt extends StatelessWidget {
  final Color goldColor;
  final DayAtmospherePhase phase;

  const KaabaSilhouetteArt({
    super.key,
    required this.goldColor,
    this.phase = DayAtmospherePhase.night,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final artWidth = (screenW * 0.42).clamp(110.0, 175.0);
    final artHeight = artWidth * 0.82;

    return SizedBox(
      width: artWidth,
      height: artHeight,
      child: CustomPaint(
        painter: MeccaSkylinePainter(goldColor: goldColor, phase: phase),
      ),
    );
  }
}
