import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// FoodHub Material Design 3 theme configuration.
/// Provides both light and dark variants.
abstract final class AppTheme {
  static const _seedColor = AppColors.primary;

  // ─────────────────────────── LIGHT THEME ────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFFDBCC),
          onPrimaryContainer: const Color(0xFF3A0A00),
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFFFE0A0),
          onSecondaryContainer: const Color(0xFF2C1A00),
          tertiary: AppColors.tertiary,
          onTertiary: Colors.white,
          error: AppColors.error,
          surface: AppColors.surfaceLight,
          onSurface: AppColors.onSurfaceLight,
          surfaceContainerHighest: AppColors.surfaceVariantLight,
          outline: AppColors.outlineLight,
        ),
        textTheme: _buildTextTheme(AppColors.onSurfaceLight),
        appBarTheme: _appBarTheme(
          background: AppColors.backgroundLight,
          foreground: AppColors.onBackgroundLight,
        ),
        cardTheme: _cardTheme(AppColors.surfaceLight),
        inputDecorationTheme: _inputTheme(
          fill: AppColors.surfaceVariantLight,
          border: AppColors.outlineLight,
        ),
        elevatedButtonTheme: _elevatedButtonTheme(),
        filledButtonTheme: _filledButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),
        chipTheme: _chipTheme(
          surface: AppColors.surfaceVariantLight,
          label: AppColors.onSurfaceLight,
        ),
        bottomNavigationBarTheme: _bottomNavTheme(
          background: AppColors.surfaceLight,
          selected: AppColors.primary,
          unselected: AppColors.outlineLight,
        ),
        navigationBarTheme: _navBarTheme(
          background: AppColors.surfaceLight,
          indicator: AppColors.primaryLight.withValues(alpha: 0.2),
          selected: AppColors.primary,
          unselected: AppColors.outlineLight,
        ),
        snackBarTheme: _snackBarTheme(),
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineLight,
          thickness: 1,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  // ─────────────────────────── DARK THEME ─────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          onPrimary: const Color(0xFF5C1400),
          primaryContainer: AppColors.primaryDark,
          onPrimaryContainer: const Color(0xFFFFDBCC),
          secondary: AppColors.secondaryLight,
          onSecondary: const Color(0xFF4A2E00),
          secondaryContainer: AppColors.secondaryDark,
          onSecondaryContainer: const Color(0xFFFFE0A0),
          tertiary: AppColors.tertiary,
          onTertiary: Colors.white,
          error: const Color(0xFFFFB4AB),
          surface: AppColors.surfaceDark,
          onSurface: AppColors.onSurfaceDark,
          surfaceContainerHighest: AppColors.surfaceVariantDark,
          outline: AppColors.outlineDark,
        ),
        textTheme: _buildTextTheme(AppColors.onSurfaceDark),
        appBarTheme: _appBarTheme(
          background: AppColors.backgroundDark,
          foreground: AppColors.onBackgroundDark,
        ),
        cardTheme: _cardTheme(AppColors.surfaceDark),
        inputDecorationTheme: _inputTheme(
          fill: AppColors.surfaceVariantDark,
          border: AppColors.outlineDark,
        ),
        elevatedButtonTheme: _elevatedButtonTheme(),
        filledButtonTheme: _filledButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Color(0xFF5C1400),
          elevation: 4,
          shape: CircleBorder(),
        ),
        chipTheme: _chipTheme(
          surface: AppColors.surfaceVariantDark,
          label: AppColors.onSurfaceDark,
        ),
        bottomNavigationBarTheme: _bottomNavTheme(
          background: AppColors.surfaceDark,
          selected: AppColors.primaryLight,
          unselected: AppColors.outlineDark,
        ),
        navigationBarTheme: _navBarTheme(
          background: AppColors.surfaceDark,
          indicator: AppColors.primaryLight.withValues(alpha: 0.2),
          selected: AppColors.primaryLight,
          unselected: AppColors.outlineDark,
        ),
        snackBarTheme: _snackBarTheme(),
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineDark,
          thickness: 1,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  // ─────────────────────────── HELPERS ────────────────────────────────────
  static TextTheme _buildTextTheme(Color color) => TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: color),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: color),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: color),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: color),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: color),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: color),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: color),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: color),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: color),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: color),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: color),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: color),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: color),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: color),
      );

  static AppBarTheme _appBarTheme({
    required Color background,
    required Color foreground,
  }) =>
      AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: foreground),
      );

  static CardThemeData _cardTheme(Color surface) => CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      );

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
  }) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static FilledButtonThemeData _filledButtonTheme() => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primary),
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static ChipThemeData _chipTheme({
    required Color surface,
    required Color label,
  }) =>
      ChipThemeData(
        backgroundColor: surface,
        labelStyle: AppTextStyles.labelMedium.copyWith(color: label),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  static BottomNavigationBarThemeData _bottomNavTheme({
    required Color background,
    required Color selected,
    required Color unselected,
  }) =>
      BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: selected,
        unselectedItemColor: unselected,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      );

  static NavigationBarThemeData _navBarTheme({
    required Color background,
    required Color indicator,
    required Color selected,
    required Color unselected,
  }) =>
      NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: indicator,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: selected);
          }
          return IconThemeData(color: unselected);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(color: selected);
          }
          return AppTextStyles.labelSmall.copyWith(color: unselected);
        }),
        elevation: 4,
      );

  static SnackBarThemeData _snackBarTheme() => SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );
}
