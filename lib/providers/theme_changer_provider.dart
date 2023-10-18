import 'package:flutter/material.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';

class ThemeChangerProvider extends ChangeNotifier{

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  ThemeChangerProvider() {
    // Initialize the theme mode from SharedPreferences when the provider is created
    getThemeModePreference().then((themeMode) {
      if (themeMode != null) {
        _themeMode = themeMode;
        notifyListeners();
      }
    });
  }

  void toggleTheme () {
    _themeMode = _themeMode == ThemeMode.light ?  ThemeMode.dark : ThemeMode.light;
    saveThemeModePreference(_themeMode);
    notifyListeners();
  }
}

