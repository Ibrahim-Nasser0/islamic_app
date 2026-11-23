import 'package:flutter/material.dart';

/// Enum representing the atmospheric phase of the day based on prayer/sun cycle
enum DayAtmospherePhase {
  dawn, // الفجر والشروق: سكون الصباح واللون الوردي المذهب
  noon, // الظهر: شمس صافية وتدرج نهاري زمردي مشرق
  afternoon, // العصر: ضوء كهرماني دافئ وهادئ
  sunset, // المغرب: شفق المساء وتدرج قرمزي مع كحلي داكن
  night, // العشاء والليل: سماء ليلية مرصعة بالنجوم وهلال فضي
}

/// Helper model for dynamic atmosphere styling
class DayAtmosphere {
  final DayAtmospherePhase phase;
  final String label;
  final List<Color> gradientColors;
  final Color accentColor;
  final IconData skyIcon;

  const DayAtmosphere({
    required this.phase,
    required this.label,
    required this.gradientColors,
    required this.accentColor,
    required this.skyIcon,
  });

  /// Resolves the current atmosphere based on the active hour
  static DayAtmosphere resolveCurrent([DateTime? now]) {
    final current = now ?? DateTime.now();
    final hour = current.hour;

    if (hour >= 4 && hour < 6) {
      // Dawn (الفجر)
      return const DayAtmosphere(
        phase: DayAtmospherePhase.dawn,
        label: 'وقت الفجر والتبكير',
        gradientColors: [Color(0xFF132228), Color(0xFF1D3B3C), Color(0xFF2E5953)],
        accentColor: Color(0xFFE8C172),
        skyIcon: Icons.wb_twilight_rounded,
      );
    } else if (hour >= 6 && hour < 12) {
      // Morning / Noon (الشروق والظهر)
      return const DayAtmosphere(
        phase: DayAtmospherePhase.noon,
        label: 'وقت الضحى والنهار',
        gradientColors: [Color(0xFF134E43), Color(0xFF1B5E4F), Color(0xFF267362)],
        accentColor: Color(0xFFF3D279),
        skyIcon: Icons.wb_sunny_rounded,
      );
    } else if (hour >= 12 && hour < 16) {
      // Afternoon (الظهر والعصر)
      return const DayAtmosphere(
        phase: DayAtmospherePhase.afternoon,
        label: 'وقت العصر والسكينة',
        gradientColors: [Color(0xFF1B4E41), Color(0xFF334E39), Color(0xFF6B582E)],
        accentColor: Color(0xFFE5B558),
        skyIcon: Icons.wb_cloudy_rounded,
      );
    } else if (hour >= 16 && hour < 19) {
      // Sunset (المغرب)
      return const DayAtmosphere(
        phase: DayAtmospherePhase.sunset,
        label: 'وقت الغروب والشفق',
        gradientColors: [Color(0xFF1B232E), Color(0xFF3B2836), Color(0xFF593335)],
        accentColor: Color(0xFFEFA259),
        skyIcon: Icons.brightness_medium_rounded,
      );
    } else {
      // Night (العشاء والليل)
      return const DayAtmosphere(
        phase: DayAtmospherePhase.night,
        label: 'سكينة الليل والتهجد',
        gradientColors: [Color(0xFF0C1318), Color(0xFF121F24), Color(0xFF182D32)],
        accentColor: Color(0xFFD4AF37),
        skyIcon: Icons.nightlight_round,
      );
    }
  }
}
