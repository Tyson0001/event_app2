import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold), // headline1
      displayMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600), // headline2
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16), // bodyText1
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 14), // bodyText2
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Replace 'primary' with 'backgroundColor'
        foregroundColor: Colors.white, // Replace 'onPrimary' with 'foregroundColor'
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey,
      secondary: Colors.blueAccent,
      surface: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), // headline1
      displayMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600), // headline2
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16), // bodyText1
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14), // bodyText2
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey, // Replace 'primary' with 'backgroundColor'
        foregroundColor: Colors.white, // Replace 'onPrimary' with 'foregroundColor'
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}
