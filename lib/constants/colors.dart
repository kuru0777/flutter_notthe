import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primaryLight = Colors.amber;
  static const MaterialColor primaryDark = Colors.deepPurple;
  static const Color secondaryLight = Colors.deepPurple;
  static const Color secondaryDark = Colors.amber;

  static const Color gradientDarkStart = Color(0xFF2C1F63);
  static const Color gradientDarkEnd = Color(0xFF1A237E);

  static Color getPrimaryColor(bool isDarkMode) =>
      isDarkMode ? primaryDark : primaryLight;

  static Color getSecondaryColor(bool isDarkMode) =>
      isDarkMode ? secondaryDark : secondaryLight;

  static List<Color> getGradientColors(bool isDarkMode) =>
      isDarkMode
          ? [gradientDarkStart, gradientDarkEnd]
          : [primaryLight.shade300, primaryDark.shade300];
}
