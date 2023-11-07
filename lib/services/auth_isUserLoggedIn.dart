import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

  Future<void> saveLoginState(bool isLoggedIn) async {
    final box = await Hive.openBox('loginState');
   await box.put('isUserLoggedIn', isLoggedIn);
  }

  Future<bool> getLoginState() async {
     final box = await Hive.openBox('loginState');
     return box.get('isUserLoggedIn', defaultValue: false);
  }

  Future<void> saveThemeModePreference(ThemeMode themeMode) async {
      final box = await Hive.openBox('themePreferences');
      await box.put('theme_mode', themeMode);
  }

  Future<ThemeMode> getThemeModePreference() async {
      final box = await Hive.openBox('themePreferences');
      return box.get('theme_mode', defaultValue: ThemeMode.light);
  }

  Future<void> clearThemeMode() async {
      final box = await Hive.openBox('themePreferences');
      await box.delete('theme_mode');
      await box.close();
}
