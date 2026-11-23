import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application Typography
/// Centralized text style definitions for the Islamic App
class AppTypography {
  AppTypography._();

  // Base Font Family (Cairo for Arabic UI clarity)
  static String get fontFamily => GoogleFonts.cairo().fontFamily!;

  // Quran Font Family (Amiri for Quranic and Hadith verses)
  static String get quranFontFamily => GoogleFonts.amiri().fontFamily!;

  // Heading Styles
  static TextStyle h1 = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle h2 = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle h3 = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle h4 = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle h5 = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle h6 = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Text Styles
  static TextStyle bodyLarge = GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Button Text Style
  static TextStyle button = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Quran & Azkar Specific Text Styles
  static TextStyle quranAyah = GoogleFonts.amiri(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 2.1,
  );

  static TextStyle quranTranslation = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  static TextStyle dhikrText = GoogleFonts.amiri(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.8,
  );

  // Label Text Styles
  static TextStyle labelLarge = GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static TextStyle labelMedium = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = GoogleFonts.cairo(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );
}
