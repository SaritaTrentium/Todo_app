import 'package:flutter/material.dart';
import 'package:todo_app/theme/my_theme.dart';

class ThemeChangerProvider extends ChangeNotifier{

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme () {
    _themeMode = _themeMode == ThemeMode.light ?  ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

