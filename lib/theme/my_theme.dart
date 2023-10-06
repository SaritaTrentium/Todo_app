import 'package:flutter/material.dart';

class MyTheme{

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColorDark: Colors.tealAccent,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.grey[900]!,
      secondary: Colors.grey[80]!,
      onBackground: Colors.tealAccent,
    ),
    scaffoldBackgroundColor: Colors.black,
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColorLight: Colors.blue,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.teal,
    secondary: Colors.white,
    onBackground: Colors.blue,
  ),
);
}