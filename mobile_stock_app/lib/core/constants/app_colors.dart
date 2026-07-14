import 'package:flutter/material.dart';

/// Centralized color palette for the entire application.
/// Do NOT hardcode colors anywhere else — always reference this class.
class AppColors {
  AppColors._();

  // ---- Brand Palette ----
  static const Color darkNavy = Color(0xFF0A0E27);
  static const Color darkNavyLight = Color(0xFF141A3D);
  static const Color electricBlue = Color(0xFF2962FF);
  static const Color electricBlueLight = Color(0xFF5B8CFF);
  static const Color cyanAccent = Color(0xFF00E5FF);
  static const Color cyanAccentSoft = Color(0xFF6BF4FF);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F7FB);

  // ---- Gradients ----
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricBlue, cyanAccent],
  );

  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkNavy, darkNavyLight],
  );

  static LinearGradient glassGradient(bool isDark) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.02)]
            : [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.25)],
      );

  // ---- Semantic Colors ----
  static const Color success = Color(0xFF00C48C);
  static const Color warning = Color(0xFFFFA726);
  static const Color danger = Color(0xFFFF5370);
  static const Color info = electricBlue;

  // Stock status colors
  static const Color inStock = success;
  static const Color lowStock = warning;
  static const Color outOfStock = danger;

  // ---- Light Theme Surfaces ----
  static const Color lightBackground = offWhite;
  static const Color lightSurface = pureWhite;
  static const Color lightSurfaceVariant = Color(0xFFEDF1F7);
  static const Color lightTextPrimary = Color(0xFF11142A);
  static const Color lightTextSecondary = Color(0xFF6E7391);
  static const Color lightBorder = Color(0xFFE3E7EF);

  // ---- Dark Theme Surfaces ----
  static const Color darkBackground = darkNavy;
  static const Color darkSurface = Color(0xFF121736);
  static const Color darkSurfaceVariant = Color(0xFF1B2147);
  static const Color darkTextPrimary = Color(0xFFF5F7FB);
  static const Color darkTextSecondary = Color(0xFFA0A5C4);
  static const Color darkBorder = Color(0xFF262C55);

  // Category accent colors (used for chips/badges, cycles through list)
  static const List<Color> categoryAccents = [
    electricBlue,
    cyanAccent,
    Color(0xFF7C4DFF),
    Color(0xFFFF6E9C),
    Color(0xFFFFB74D),
    Color(0xFF4DD0E1),
  ];
}
