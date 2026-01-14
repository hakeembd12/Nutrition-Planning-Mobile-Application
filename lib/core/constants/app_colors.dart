import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Green theme for nutrition/health
  static const primary = Color(0xFF4CAF50);
  static const primaryLight = Color(0xFF81C784);
  static const primaryDark = Color(0xFF388E3C);

  // Secondary Colors - Teal
  static const secondary = Color(0xFF00BCD4);
  static const secondaryLight = Color(0xFF4DD0E1);
  static const secondaryDark = Color(0xFF0097A7);

  // Neutral Colors
  static const background = Color(0xFFF8F9FA);
  static const surface = Colors.white;
  static const surfaceDark = Color(0xFF1E1E2E);

  // Text Colors
  static const textPrimary = Color(0xFF2D3436);
  static const textSecondary = Color(0xFF636E72);
  static const textLight = Color(0xFFB2BEC3);

  // Semantic Colors
  static const success = Color(0xFF00B894);
  static const error = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFDCB6E);
  static const info = Color(0xFF74B9FF);

  // Nutrition Colors
  static const calories = Color(0xFFFF6B6B);
  static const protein = Color(0xFF4ECDC4);
  static const carbs = Color(0xFFFFA502);
  static const fats = Color(0xFFFFD93D);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
