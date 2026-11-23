import 'package:material_ui/material_ui.dart';

class LocalizationManager {
  LocalizationManager._();

  static const String translationsPath = 'assets/lang';
  static const Locale fallbackLocale = Locale('ar');
  static const Locale defaultLocale = Locale('ar');

  static const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];
}
