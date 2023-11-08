import 'package:flutter/material.dart';
import 'package:todo_app/screens/brightness_observer.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';

class ThemeChangerProvider extends ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // Notify listeners after the theme changes
    saveThemeModePreference(_themeMode);
  }

  ThemeChangerProvider() {
    initThemeModePreference();
  }

  void toggleTheme() {
    _themeMode =
    _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    saveThemeModePreference(_themeMode);
    notifyListeners();
  }

  void resetThemeMode() {
    _themeMode = ThemeMode.system;
    clearThemeMode();
    notifyListeners();
  }

  void initThemeModePreference() {
    // Initialize the theme mode from SharedPreferences when the provider is created
    getThemeModePreference().then((themeMode) {
      _themeMode = themeMode;
      notifyListeners();
        });
  }

  void listenForSystemBrightnessChange() {
    WidgetsBinding.instance.addObserver(BrightnessObserver(
      onBrightnessChanged: (brightness) {
        if (_themeMode == ThemeMode.system) {
          // Only change the app's theme when it's set to system mode
          if (brightness == Brightness.light) {
            _themeMode = ThemeMode.light;
          } else {
            _themeMode = ThemeMode.dark;
          }
          notifyListeners();
        }
      },
    ) as WidgetsBindingObserver);
  }
}

