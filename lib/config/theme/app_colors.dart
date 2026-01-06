import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF007AFF);
  static const Color secondary = Color(0xFF5AC8FA);

  // Neutral colors
  static const Color surface = Color(0xFFFAFAFA);
  static const Color background = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  // Semantic colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF00B4DB);

  // UI colors
  static const Color border = Color(0xFFE5E5EA);
  static const Color divider = Color(0xFFC7C7CC);
  static const Color shadow = Color(0x1F000000);

  // Input colors
  static const Color inputBackground = Color(0xFFF2F2F7);
  static const Color inputBorder = Color(0xFFE5E5EA);
  static const Color inputFocus = Color(0xFF007AFF);

  // Disabled
  static const Color disabled = Color(0xFFCCCCCC);
  static const Color disabledText = Color(0xFF999999);
}
