import 'package:flutter/material.dart';

/// Central color palette for FoodHub.
/// All colors are derived from the seed: a warm orange-amber brand color.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFE8621A);
  static const Color primaryLight = Color(0xFFFF8A50);
  static const Color primaryDark = Color(0xFFBF4000);

  // Secondary (warm yellow)
  static const Color secondary = Color(0xFFF5A623);
  static const Color secondaryLight = Color(0xFFFFD04F);
  static const Color secondaryDark = Color(0xFFBF7800);

  // Tertiary (fresh green for "healthy")
  static const Color tertiary = Color(0xFF4CAF50);

  // Neutrals — Light Theme
  static const Color backgroundLight = Color(0xFFFFFBF7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF5EDDF);
  static const Color onBackgroundLight = Color(0xFF1C1410);
  static const Color onSurfaceLight = Color(0xFF1C1410);
  static const Color outlineLight = Color(0xFFCCC0B4);

  // Neutrals — Dark Theme
  static const Color backgroundDark = Color(0xFF151210);
  static const Color surfaceDark = Color(0xFF231E1A);
  static const Color surfaceVariantDark = Color(0xFF2E2720);
  static const Color onBackgroundDark = Color(0xFFF2E9DF);
  static const Color onSurfaceDark = Color(0xFFF2E9DF);
  static const Color outlineDark = Color(0xFF504540);

  // Semantic
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57F17);

  // Gradient stops
  static const List<Color> heroGradient = [
    Color(0x00000000),
    Color(0xCC000000),
  ];
}
