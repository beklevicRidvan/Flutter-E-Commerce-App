import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.red.shade700),

  appBarTheme:  AppBarTheme(backgroundColor: Colors.red.shade700),
  fontFamily: 'OpenSans',

  colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade700,
      tertiary: Colors.grey.shade800,
      inversePrimary: Colors.grey.shade300,
    surface: Colors.white,
  ),
);