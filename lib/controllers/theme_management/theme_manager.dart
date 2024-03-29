import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class ThemeManager {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: ThemeConfig.primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeConfig.primaryColor,
      ),
      // Define other properties for the light theme
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: ThemeConfig.primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeConfig.primaryColor,
      ),
      // Define other properties for the dark theme
    );
  }
}
