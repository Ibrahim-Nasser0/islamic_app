import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences? _prefs;

  ThemeCubit({SharedPreferences? sharedPreferences})
      : _prefs = sharedPreferences,
        super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await _getPrefs();
    final savedMode = prefs.getString(AppConstants.themeKey);
    if (savedMode == 'light') {
      emit(ThemeMode.light);
    } else if (savedMode == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    final prefs = await _getPrefs();
    String val = 'system';
    if (mode == ThemeMode.light) {
      val = 'light';
    } else if (mode == ThemeMode.dark) {
      val = 'dark';
    }
    await prefs.setString(AppConstants.themeKey, val);
  }
}
