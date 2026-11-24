import 'package:material_ui/material_ui.dart';

/// Islamic App Color Constants - Royal Emerald & Warm Gold
class AppColors {
  AppColors._();

  // Primary Colors (Royal Emerald)
  static const Color primary = Color(0xFF1B5E4F);
  static const Color primaryDark = Color(0xFF13453A);
  static const Color primaryLight = Color(0xFF2A8772);
  static const Color primarySubtle = Color(0xFFE8F3EF);

  // Secondary Colors (Muted Islamic Gold)
  static const Color secondary = Color(0xFFC5A059);
  static const Color secondaryDark = Color(0xFFA6823B);
  static const Color secondaryLight = Color(0xFFD8B467);
  static const Color secondarySubtle = Color(0xFFF9F4EA);

  // Accent Colors
  static const Color accent = Color(0xFFD8B467);
  static const Color accentDark = Color(0xFFC5A059);
  static const Color accentLight = Color(0xFFEAD49B);

  // Quran & Reading Specific Colors
  static const Color quranPage = Color(0xFFFBF7EE);
  static const Color quranPageDark = Color(0xFF0B1411);
  static const Color quranAyahText = Color(0xFF19211E);
  static const Color quranAyahTextDark = Color(0xFFF4EFE4);

  // Prayer & Dhikr Specific Colors
  static const Color prayerActive = Color(0xFFC5A059);
  static const Color prayerCardDark = Color(0xFF0F1E19);
  static const Color dhikrCounter = Color(0xFF1B5E4F);

  // Background Colors (Celestial Obsidian aligned with Landing Page)
  static const Color background = Color(0xFFF8F9F6);
  static const Color backgroundDark = Color(0xFF07100D);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF0D1915);
  static const Color surfaceSubtle = Color(0xFFF2F5F3);
  static const Color surfaceSubtleDark = Color(0xFF12231D);

  // Text Colors
  static const Color textPrimary = Color(0xFF19211E);
  static const Color textSecondary = Color(0xFF5F7068);
  static const Color textLight = Color(0xFF9AA8A1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDarkPrimary = Color(0xFFF4EFE4);
  static const Color textDarkSecondary = Color(0xFF92A49B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  // Border & Divider Colors
  static const Color border = Color(0xFFE1E8E4);
  static const Color borderDark = Color(0xFF21362D);
  static const Color divider = Color(0xFFEDF2EE);
  static const Color dividerDark = Color(0xFF15251F);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF13453A)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD8B467), Color(0xFFC5A059)],
  );

  static const LinearGradient accentGradient = goldGradient;

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, surfaceDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF10B981)],
  );
}
