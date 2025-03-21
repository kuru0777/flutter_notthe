import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  static InputDecoration getInputDecoration(String hintText, bool isDarkMode) {
    return InputDecoration(
      hintText: hintText,
      border: _getBorder(isDarkMode),
      enabledBorder: _getBorder(isDarkMode),
      focusedBorder: _getBorder(isDarkMode, isFocused: true),
    );
  }

  static OutlineInputBorder _getBorder(
    bool isDarkMode, {
    bool isFocused = false,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color:
            isFocused
                ? AppColors.getSecondaryColor(isDarkMode)
                : AppColors.getPrimaryColor(isDarkMode),
        width: isFocused ? 2 : 1,
      ),
    );
  }

  static BoxDecoration getNoteCardDecoration(bool isDarkMode) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: AppColors.getGradientColors(isDarkMode),
      ),
    );
  }
}
