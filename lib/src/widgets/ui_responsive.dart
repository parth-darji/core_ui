import 'package:flutter/material.dart';

/// Helper class to query responsiveness breakpoints.
class UIResponsive {
  static const double mobileMax = 799.0;
  static const double tabletMax = 1199.0;

  static bool isMobile(BuildContext context, {double breakpoint = 800.0}) {
    return MediaQuery.of(context).size.width < breakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 800.0 && width <= tabletMax;
  }

  static bool isDesktop(BuildContext context, {double breakpoint = 800.0}) {
    return MediaQuery.of(context).size.width >= breakpoint;
  }

  static int gridColumns(BuildContext context, {double targetWidth = 360.0}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 800.0) return 1;
    final contentWidth = width - 260.0;
    final cols = (contentWidth / targetWidth).floor();
    return cols < 1 ? 1 : (cols > 4 ? 4 : cols);
  }
}

/// A layout widget that switches between mobile, tablet (optional), and desktop layouts.
class UIResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final double desktopBreakpoint;

  const UIResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.desktopBreakpoint = 800.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopBreakpoint) {
          return desktop;
        }
        if (tablet != null && constraints.maxWidth >= 600.0) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
