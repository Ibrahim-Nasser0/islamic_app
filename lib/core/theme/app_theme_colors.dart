import 'package:material_ui/material_ui.dart';
import 'app_theme_color_presets.dart';

/// AppThemeColors ThemeExtension enabling zero-conditional theme access via context.appColors.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color quranPageBackground;
  final Color quranAyahText;
  final Color activePrayerHighlight;
  final Color prayerCardBg;
  final Color dhikrCounterBg;
  final Color surfaceSubtle;
  final Color badgeBackground;
  final Color accentGold;
  final Color cardBorder;
  final List<BoxShadow> cardShadow;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color statusSuccess;
  final Color statusWarning;
  final Color statusError;
  final Color statusInfo;
  final String mapTileUrl;
  final ColorFilter? mapColorFilter;
  final Color navCapsuleBg;
  final Color navCapsuleBorder;
  final Color navActivePillBg;
  final Color emeraldBevelTop;
  final Color emeraldBevelBottom;

  const AppThemeColors({
    required this.quranPageBackground,
    required this.quranAyahText,
    required this.activePrayerHighlight,
    required this.prayerCardBg,
    required this.dhikrCounterBg,
    required this.surfaceSubtle,
    required this.badgeBackground,
    required this.accentGold,
    required this.cardBorder,
    required this.cardShadow,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.statusSuccess,
    required this.statusWarning,
    required this.statusError,
    required this.statusInfo,
    required this.mapTileUrl,
    this.mapColorFilter,
    required this.navCapsuleBg,
    required this.navCapsuleBorder,
    required this.navActivePillBg,
    required this.emeraldBevelTop,
    required this.emeraldBevelBottom,
  });

  static AppThemeColors get light => AppThemeColorPresets.light;
  static AppThemeColors get dark => AppThemeColorPresets.dark;

  @override
  ThemeExtension<AppThemeColors> copyWith({
    Color? quranPageBackground,
    Color? quranAyahText,
    Color? activePrayerHighlight,
    Color? prayerCardBg,
    Color? dhikrCounterBg,
    Color? surfaceSubtle,
    Color? badgeBackground,
    Color? accentGold,
    Color? cardBorder,
    List<BoxShadow>? cardShadow,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? statusSuccess,
    Color? statusWarning,
    Color? statusError,
    Color? statusInfo,
    String? mapTileUrl,
    ColorFilter? mapColorFilter,
    Color? navCapsuleBg,
    Color? navCapsuleBorder,
    Color? navActivePillBg,
    Color? emeraldBevelTop,
    Color? emeraldBevelBottom,
  }) {
    return AppThemeColors(
      quranPageBackground: quranPageBackground ?? this.quranPageBackground,
      quranAyahText: quranAyahText ?? this.quranAyahText,
      activePrayerHighlight: activePrayerHighlight ?? this.activePrayerHighlight,
      prayerCardBg: prayerCardBg ?? this.prayerCardBg,
      dhikrCounterBg: dhikrCounterBg ?? this.dhikrCounterBg,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      accentGold: accentGold ?? this.accentGold,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusWarning: statusWarning ?? this.statusWarning,
      statusError: statusError ?? this.statusError,
      statusInfo: statusInfo ?? this.statusInfo,
      mapTileUrl: mapTileUrl ?? this.mapTileUrl,
      mapColorFilter: mapColorFilter ?? this.mapColorFilter,
      navCapsuleBg: navCapsuleBg ?? this.navCapsuleBg,
      navCapsuleBorder: navCapsuleBorder ?? this.navCapsuleBorder,
      navActivePillBg: navActivePillBg ?? this.navActivePillBg,
      emeraldBevelTop: emeraldBevelTop ?? this.emeraldBevelTop,
      emeraldBevelBottom: emeraldBevelBottom ?? this.emeraldBevelBottom,
    );
  }

  @override
  ThemeExtension<AppThemeColors> lerp(
    covariant ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      quranPageBackground: Color.lerp(quranPageBackground, other.quranPageBackground, t)!,
      quranAyahText: Color.lerp(quranAyahText, other.quranAyahText, t)!,
      activePrayerHighlight: Color.lerp(activePrayerHighlight, other.activePrayerHighlight, t)!,
      prayerCardBg: Color.lerp(prayerCardBg, other.prayerCardBg, t)!,
      dhikrCounterBg: Color.lerp(dhikrCounterBg, other.dhikrCounterBg, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      mapTileUrl: t < 0.5 ? mapTileUrl : other.mapTileUrl,
      mapColorFilter: t < 0.5 ? mapColorFilter : other.mapColorFilter,
      navCapsuleBg: Color.lerp(navCapsuleBg, other.navCapsuleBg, t)!,
      navCapsuleBorder: Color.lerp(navCapsuleBorder, other.navCapsuleBorder, t)!,
      navActivePillBg: Color.lerp(navActivePillBg, other.navActivePillBg, t)!,
      emeraldBevelTop: Color.lerp(emeraldBevelTop, other.emeraldBevelTop, t)!,
      emeraldBevelBottom: Color.lerp(emeraldBevelBottom, other.emeraldBevelBottom, t)!,
    );
  }
}
