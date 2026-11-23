import 'package:material_ui/material_ui.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

/// Application Theme Configuration
/// Provides Light and Dark theme configurations for the Islamic App
class AppTheme {
  AppTheme._();

  /// Light Theme Configuration
  static ThemeData get lightTheme => buildLightTheme();

  /// Dark Theme Configuration
  static ThemeData get darkTheme => buildDarkTheme();
}
