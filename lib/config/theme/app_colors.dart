import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Colors - App Theme (Onboarding, Auth, Main Screens)
  static const Color primary = Color(0xFF6EC6C2);
  static const Color secondary = Color(0xFF6EC6C2);
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2D2B);
  static const Color textSecondary = Color(0xFF6B7C7A);
  static const Color textTertiary = Color(0xFF6B7C7A);
  
  // UI Element Colors
  static const Color illustrationGray = Color(0xFFB0B7B6);
  static const Color divider = Color(0xFFE5EDED);
  static const Color border = Color(0xFFE5EDED);
  
  // Semantic Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF00B4DB);
  
  // State Colors
  static const Color disabled = Color(0xFFE5EDED);
  static const Color disabledText = Color(0xFFB0B7B6);
  
  // Shadow
  static const Color shadow = Color(0x1F000000);
  
  // Input Colors
  static const Color inputBackground = Color(0xFFF5F7F7);
  static const Color inputBorder = Color(0xFFE5EDED);
  static const Color inputFocus = Color(0xFF6EC6C2);
  
  // Splash Screen Colors (Keep Separate)
  static const Color splashPrimary = Color(0xFF8FD3CF);
  static const Color splashSecondary = Color(0xFF4FB3A5);
  static const Color splashCloudLight = Color(0xFFEAF7F6);
  static const Color splashNatureGreen = Color(0xFF7CBF9E);
}
