import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'app_theme_colors.dart';
import 'colors.dart';
import 'typography.dart';

/// Builds the Dark ThemeData for the Islamic application
ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    extensions: [AppThemeColors.dark],
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primarySubtle,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.backgroundDark,
      secondaryContainer: Color(0xFF332918),
      onSecondaryContainer: AppColors.secondaryLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textDarkPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.dividerDark,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textDarkPrimary,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTypography.h3.copyWith(color: AppColors.textDarkPrimary),
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.h1.copyWith(color: AppColors.textDarkPrimary),
      displayMedium: AppTypography.h2.copyWith(color: AppColors.textDarkPrimary),
      displaySmall: AppTypography.h3.copyWith(color: AppColors.textDarkPrimary),
      headlineMedium: AppTypography.h4.copyWith(color: AppColors.textDarkPrimary),
      titleMedium: AppTypography.h5.copyWith(color: AppColors.textDarkPrimary),
      titleSmall: AppTypography.h6.copyWith(color: AppColors.textDarkPrimary),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textDarkPrimary),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textDarkSecondary),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textDarkSecondary),
      labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textDarkPrimary),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDark, width: 0.8),
      ),
      color: AppColors.surfaceDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: AppTypography.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryLight,
        textStyle: AppTypography.button,
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.textDarkPrimary, size: 24),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: 1,
    ),
  );
}
