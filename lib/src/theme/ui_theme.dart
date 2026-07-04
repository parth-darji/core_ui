import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import '../tokens/ui_typography.dart';

/// Unified Material 3 theme configurations for the ChartSip application.
/// Manages both light and dark themes cleanly inside the design system package.
class UITheme {
  UITheme._();

  /// Standard Material 3 Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: UIColors.primaryBlue,
      scaffoldBackgroundColor: UIColors.systemBackground,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: UIColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.light(
        primary: UIColors.primaryBlue,
        onPrimary: Colors.white,
        secondary: UIColors.pitambarGold,
        onSecondary: UIColors.textPrimary,
        error: UIColors.lotusRose,
        surface: UIColors.cardBackground,
        onSurface: UIColors.textPrimary,
        onSurfaceVariant: UIColors.textSecondary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: UIColors.cardBackground,
        indicatorColor: UIColors.primaryBlue
            .withValues(alpha: 0.08), // Elegant soft blue tint
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: UIColors.primaryBlue);
          }
          return const IconThemeData(color: UIColors.textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
          if (states.contains(WidgetState.selected)) {
            return UITypography.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: UIColors.primaryBlue,
            );
          }
          return UITypography.labelSmall.copyWith(
            fontWeight: FontWeight.normal,
            color: UIColors.textSecondary,
          );
        }),
      ),
      textTheme: const TextTheme(
        displayLarge: UITypography.displayLarge,
        displayMedium: UITypography.displayMedium,
        displaySmall: UITypography.displaySmall,
        headlineLarge: UITypography.headlineLarge,
        headlineMedium: UITypography.headlineMedium,
        headlineSmall: UITypography.headlineSmall,
        titleLarge: UITypography.titleLarge,
        titleMedium: UITypography.titleMedium,
        titleSmall: UITypography.titleSmall,
        bodyLarge: UITypography.bodyLarge,
        bodyMedium: UITypography.bodyMedium,
        bodySmall: UITypography.bodySmall,
        labelLarge: UITypography.labelLarge,
        labelMedium: UITypography.labelMedium,
        labelSmall: UITypography.labelSmall,
      ),
    );
  }

  /// Standard Material 3 Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: UIColors.pitambarGold,
      scaffoldBackgroundColor: const Color(0xFF121212),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.dark(
        primary: UIColors.pitambarGold,
        onPrimary: UIColors.primaryBlue,
        secondary: UIColors.primaryBlue,
        onSecondary: Colors.white,
        error: UIColors.lotusRose,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white70,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: UIColors.pitambarGold
            .withValues(alpha: 0.15), // Elegant soft gold tint
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: UIColors.pitambarGold);
          }
          return const IconThemeData(color: Colors.white60);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
          if (states.contains(WidgetState.selected)) {
            return UITypography.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: UIColors.pitambarGold,
            );
          }
          return UITypography.labelSmall.copyWith(
            fontWeight: FontWeight.normal,
            color: Colors.white60,
          );
        }),
      ),
      textTheme: const TextTheme(
        displayLarge: UITypography.displayLarge,
        displayMedium: UITypography.displayMedium,
        displaySmall: UITypography.displaySmall,
        headlineLarge: UITypography.headlineLarge,
        headlineMedium: UITypography.headlineMedium,
        headlineSmall: UITypography.headlineSmall,
        titleLarge: UITypography.titleLarge,
        titleMedium: UITypography.titleMedium,
        titleSmall: UITypography.titleSmall,
        bodyLarge: UITypography.bodyLarge,
        bodyMedium: UITypography.bodyMedium,
        bodySmall: UITypography.bodySmall,
        labelLarge: UITypography.labelLarge,
        labelMedium: UITypography.labelMedium,
        labelSmall: UITypography.labelSmall,
      ),
    );
  }

  /// Dynamically builds the appropriate theme configuration based on [brightness].
  static ThemeData buildTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }
}
