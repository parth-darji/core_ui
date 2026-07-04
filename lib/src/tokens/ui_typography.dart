import 'package:flutter/widgets.dart';

/// Unified typography definitions for the Material 3 design system.
/// Uses standard Material 3 specifications for size, weight, letter spacing, and height.
class UITypography {
  UITypography._();

  /// Registered name of the bundled Inter font family, resolved via package prefix.
  static const String fontFamily = 'packages/core_ui/Inter';

  /// Material 3 Display Large (57pt, Regular, tracking: -0.25).
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57.0,
    fontWeight: FontWeight.normal,
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// Material 3 Display Medium (45pt, Regular, tracking: 0.0).
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.0,
    height: 1.16,
  );

  /// Material 3 Display Small (36pt, Regular, tracking: 0.0).
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.0,
    height: 1.22,
  );

  /// Material 3 Headline Large (32pt, Regular, tracking: 0.0).
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.0,
    height: 1.25,
  );

  /// Material 3 Headline Medium (28pt, Regular, tracking: 0.0).
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.0,
    height: 1.29,
  );

  /// Material 3 Headline Small (24pt, Regular, tracking: 0.0).
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.0,
    height: 1.33,
  );

  /// Material 3 Title Large (22pt, Medium, tracking: 0.0).
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
    height: 1.27,
  );

  /// Material 3 Title Medium (16pt, Medium, tracking: 0.15).
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// Material 3 Title Small (14pt, Medium, tracking: 0.1).
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Material 3 Body Large (16pt, Regular, tracking: 0.5).
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
  );

  /// Material 3 Body Medium (14pt, Regular, tracking: 0.25).
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// Material 3 Body Small (12pt, Regular, tracking: 0.4).
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.33,
  );

  /// Material 3 Label Large (14pt, Medium, tracking: 0.1).
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Material 3 Label Medium (12pt, Medium, tracking: 0.5).
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// Material 3 Label Small (11pt, Medium, tracking: 0.5).
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}
