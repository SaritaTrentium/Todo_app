import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

  Future<void> saveLoginState(bool isLoggedIn) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isUserLoggedIn', isLoggedIn);
  }

  Future<bool> getLoginState() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isUserLoggedIn') ?? false;
  }

Future<void> saveThemeModePreference(ThemeMode themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme_mode', themeMode.toString());
}

Future<ThemeMode> getThemeModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  final themeModeString = prefs.getString('theme_mode');
  return themeModeString == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light;
}