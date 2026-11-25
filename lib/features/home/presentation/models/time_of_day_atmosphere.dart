import 'package:material_ui/material_ui.dart';

/// Enum representing the atmospheric phase of the day based on sun cycle.
enum DayAtmospherePhase { dawn, noon, afternoon, sunset, night }

/// Helper model for dynamic atmosphere styling with localized phase keys.
class DayAtmosphere {
  final DayAtmospherePhase phase;
  final String phaseLabelKey;
  final List<Color> gradientColors;
  final Color accentColor;
  final IconData skyIcon;

  const DayAtmosphere({
    required this.phase,
    required this.phaseLabelKey,
    required this.gradientColors,
    required this.accentColor,
    required this.skyIcon,
  });

  /// Resolves the current atmosphere based on the active hour.
  static DayAtmosphere resolveCurrent([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;

    if (hour >= 4 && hour < 6) {
      return const DayAtmosphere(
        phase: DayAtmospherePhase.dawn,
        phaseLabelKey: 'atmosphere_dawn',
        gradientColors: [Color(0xFF132228), Color(0xFF1D3B3C), Color(0xFF2E5953)],
        accentColor: Color(0xFFE8C172),
        skyIcon: Icons.wb_twilight_rounded,
      );
    } else if (hour >= 6 && hour < 12) {
      return const DayAtmosphere(
        phase: DayAtmospherePhase.noon,
        phaseLabelKey: 'atmosphere_noon',
        gradientColors: [Color(0xFF134E43), Color(0xFF1B5E4F), Color(0xFF267362)],
        accentColor: Color(0xFFF3D279),
        skyIcon: Icons.wb_sunny_rounded,
      );
    } else if (hour >= 12 && hour < 16) {
      return const DayAtmosphere(
        phase: DayAtmospherePhase.afternoon,
        phaseLabelKey: 'atmosphere_afternoon',
        gradientColors: [Color(0xFF1B4E41), Color(0xFF334E39), Color(0xFF6B582E)],
        accentColor: Color(0xFFE5B558),
        skyIcon: Icons.wb_cloudy_rounded,
      );
    } else if (hour >= 16 && hour < 19) {
      return const DayAtmosphere(
        phase: DayAtmospherePhase.sunset,
        phaseLabelKey: 'atmosphere_sunset',
        gradientColors: [Color(0xFF1B232E), Color(0xFF3B2836), Color(0xFF593335)],
        accentColor: Color(0xFFEFA259),
        skyIcon: Icons.brightness_medium_rounded,
      );
    } else {
      return const DayAtmosphere(
        phase: DayAtmospherePhase.night,
        phaseLabelKey: 'atmosphere_night',
        gradientColors: [Color(0xFF0C1318), Color(0xFF121F24), Color(0xFF182D32)],
        accentColor: Color(0xFFD4AF37),
        skyIcon: Icons.nightlight_round,
      );
    }
  }
}
