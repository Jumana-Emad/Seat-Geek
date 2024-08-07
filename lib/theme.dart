import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      surface: Colors.orange.shade700,
      primary: Colors.black,
      inversePrimary: Colors.lightBlue.shade500,
      secondary: Colors.purpleAccent.shade400),
);
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      surface: Colors.indigoAccent.shade700,
      primary: Colors.white,
      inversePrimary: Colors.lightBlue.shade900,
      secondary: Colors.purpleAccent.shade700),
);
