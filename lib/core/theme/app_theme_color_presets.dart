import 'package:material_ui/material_ui.dart';
import 'app_theme_colors.dart';
import 'colors.dart';

/// Light and Dark semantic token presets aligned with Celestial Obsidian sanctuary.
class AppThemeColorPresets {
  AppThemeColorPresets._();

  static AppThemeColors get light => AppThemeColors(
    quranPageBackground: AppColors.quranPage,
    quranAyahText: AppColors.quranAyahText,
    activePrayerHighlight: AppColors.prayerActive,
    prayerCardBg: AppColors.surface,
    dhikrCounterBg: AppColors.primarySubtle,
    surfaceSubtle: AppColors.surfaceSubtle,
    badgeBackground: AppColors.primarySubtle,
    accentGold: AppColors.secondary,
    cardBorder: AppColors.border,
    cardShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.05),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textLight,
    statusSuccess: AppColors.success,
    statusWarning: AppColors.warning,
    statusError: AppColors.error,
    statusInfo: AppColors.info,
    mapTileUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    mapColorFilter: null,
    navCapsuleBg: AppColors.surface,
    navCapsuleBorder: AppColors.secondary.withValues(alpha: 0.35),
    navActivePillBg: AppColors.primarySubtle,
    emeraldBevelTop: AppColors.primaryLight,
    emeraldBevelBottom: AppColors.primaryDark,
  );

  static AppThemeColors get dark => AppThemeColors(
    quranPageBackground: AppColors.quranPageDark,
    quranAyahText: AppColors.quranAyahTextDark,
    activePrayerHighlight: AppColors.secondaryLight,
    prayerCardBg: AppColors.prayerCardDark,
    dhikrCounterBg: AppColors.surfaceSubtleDark,
    surfaceSubtle: AppColors.surfaceSubtleDark,
    badgeBackground: AppColors.primaryDark.withValues(alpha: 0.45),
    accentGold: AppColors.secondaryLight,
    cardBorder: AppColors.secondaryLight.withValues(alpha: 0.18),
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.32),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
    textPrimary: AppColors.textDarkPrimary,
    textSecondary: AppColors.textDarkSecondary,
    textMuted: AppColors.textLight,
    statusSuccess: AppColors.success,
    statusWarning: AppColors.warning,
    statusError: AppColors.error,
    statusInfo: AppColors.info,
    mapTileUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    mapColorFilter: const ColorFilter.matrix(<double>[
      -0.22, -0.68, -0.10, 0, 225,
      -0.20, -0.65, -0.10, 0, 225,
      -0.22, -0.68, -0.10, 0, 230,
      0,     0,     0,    1, 0,
    ]),
    navCapsuleBg: const Color(0xFF0A1612),
    navCapsuleBorder: AppColors.secondaryLight.withValues(alpha: 0.25),
    navActivePillBg: AppColors.primaryDark.withValues(alpha: 0.72),
    emeraldBevelTop: const Color(0xFF216E5C),
    emeraldBevelBottom: AppColors.primaryDark,
  );
}
