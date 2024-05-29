import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.red),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
  fontFamily: 'OpenSans',
  colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.grey.shade500,
      secondary: Colors.grey.shade200,
      tertiary: Colors.white,
      inversePrimary: Colors.grey.shade900,
    surface: Colors.black,
  ),
);