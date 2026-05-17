import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// MD3-compatible text styles using Outfit font via google_fonts.
abstract final class AppTextStyles {
  // Display
  static TextStyle get displayLarge => GoogleFonts.nunito(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => GoogleFonts.nunito(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
      );

  // Headline
  static TextStyle get headlineLarge => GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
      );

  static TextStyle get headlineSmall => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
      );

  // Title
  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
      );

  static TextStyle get titleMedium => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      );

  static TextStyle get titleSmall => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // Label
  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelMedium => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle get labelSmall => GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // App-specific
  static TextStyle get recipeTitle => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.onSurfaceLight,
      );

  static TextStyle get categoryLabel => GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );
}
