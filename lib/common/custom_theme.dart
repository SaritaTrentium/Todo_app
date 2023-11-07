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
    focusColor: Colors.grey,
    textTheme: TextTheme(
      displayMedium: TextStyle(color: Colors.white24),
      displaySmall: TextStyle(color: Colors.grey),
      headlineLarge: TextStyle(fontSize:40,fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 14),
      bodyLarge: TextStyle(fontSize: 16),
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
    focusColor: Colors.deepPurple.shade300,
    textTheme: TextTheme(
      displayMedium: TextStyle(color: Colors.white24),
      displaySmall: TextStyle(color: Colors.deepPurple),
      headlineLarge: TextStyle(color: Colors.purple.shade400,fontSize:40,fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Colors.purple.shade50,
);
}