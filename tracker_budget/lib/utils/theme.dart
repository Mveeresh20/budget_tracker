import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness:
        Brightness.light, // Make sure this matches ColorScheme brightness
    colorScheme: ColorScheme.light(
      brightness: Brightness.light, // Must match ThemeData brightness
      primary: Colors.blue,
      secondary: Colors.amber,
      // Add other color scheme properties as needed
    ),
    // Define other theme properties here
  );

  static final darkTheme = ThemeData(
    brightness:
        Brightness.dark, // Make sure this matches ColorScheme brightness
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark, // Must match ThemeData brightness
      primary: Colors.blueGrey,
      secondary: Colors.cyan,
      // Add other color scheme properties as needed
    ),
    // Define other theme properties here
  );
}
