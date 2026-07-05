import 'package:flutter/material.dart';

/// A utility widget that provides consistent bottom safe area padding
/// across all screens, bottom sheets, and modals.
/// It dynamically adjusts spacing to accommodate modern system gesture indicators
/// (~34dp) or legacy Android 3-button navigation bars (~48dp), and uses a clean
/// fallback spacing (16dp) when no system navigation bar is present.
class UISafeBottomSpacing extends StatelessWidget {
  /// The fallback margin when the system reports 0 bottom safe area padding.
  final double fallbackMargin;

  const UISafeBottomSpacing({
    super.key,
    this.fallbackMargin = 16.0,
  });

  /// Helper to calculate the active safe bottom padding dynamically.
  static double getPadding(BuildContext context,
      {double fallbackMargin = 16.0}) {
    final view = View.of(context);
    if (view.viewInsets.bottom > 0) {
      return 0.0;
    }
    final systemBottom = view.padding.bottom / view.devicePixelRatio;
    return systemBottom > 0 ? systemBottom : fallbackMargin;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: getPadding(context, fallbackMargin: fallbackMargin));
  }
}
