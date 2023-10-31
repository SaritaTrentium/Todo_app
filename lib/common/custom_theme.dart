import 'package:flutter/material.dart';

class CustomTheme{

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: Colors.black12,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.grey[900]!,
      secondary: Colors.grey[80]!,
      onBackground: Colors.black12,
    ),
    scaffoldBackgroundColor: Colors.black,
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurpleAccent,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.teal,
    secondary: Colors.white,
    onBackground: Colors.deepPurpleAccent,
  ),
    scaffoldBackgroundColor: Colors.purple.shade50,
);
}