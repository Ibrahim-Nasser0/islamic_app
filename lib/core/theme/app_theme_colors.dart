import 'package:material_ui/material_ui.dart';

import 'colors.dart';

/// AppThemeColors ThemeExtension for Islamic App
/// Enables zero-conditional theme access via context.appColors
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
  });

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
        color: AppColors.primary.withValues(alpha: 0.04),
        blurRadius: 10,
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
  );

  static AppThemeColors get dark => AppThemeColors(
    quranPageBackground: AppColors.quranPageDark,
    quranAyahText: AppColors.quranAyahTextDark,
    activePrayerHighlight: AppColors.secondaryLight,
    prayerCardBg: AppColors.prayerCardDark,
    dhikrCounterBg: AppColors.surfaceSubtleDark,
    surfaceSubtle: AppColors.surfaceSubtleDark,
    badgeBackground: AppColors.primaryDark.withValues(alpha: 0.3),
    accentGold: AppColors.secondaryLight,
    cardBorder: AppColors.borderDark,
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.25),
        blurRadius: 10,
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
  );

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
    );
  }
}
