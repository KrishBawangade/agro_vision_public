import 'package:agro_vision/utils/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  // 🌞 Light theme configuration using a seeded color scheme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,            // Set theme brightness to light
      contrastLevel: 0,                         // Default contrast level
      seedColor: lightPrimary,                  // Use your app's light primary color as base
      dynamicSchemeVariant: DynamicSchemeVariant.rainbow, // Enable dynamic rainbow color variant
    ),
  );

  // 🌙 Dark theme configuration using a seeded color scheme
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,             // Set theme brightness to dark
      contrastLevel: 1,                         // Increased contrast for better readability
      seedColor: lightPrimary,                  // Same base color for consistency
      dynamicSchemeVariant: DynamicSchemeVariant.rainbow, // Same variant for both modes
    ),
  );
}
