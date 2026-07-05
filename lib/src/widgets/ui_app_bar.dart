import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/ui_typography.dart';

/// Reusable Material 3 AppBar.
class UIAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const UIAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Frosted glass tint color
    final tintColor = isDark 
        ? const Color(0xFF0F172A).withValues(alpha: 0.8) // Dark mode background tint
        : const Color(0xFFF8FAFC).withValues(alpha: 0.8); // Light mode background tint

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          color: tintColor,
          child: AppBar(
            title: Text(
              title,
              style: UITypography.titleLarge.copyWith(
                color: resolvedColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: leading,
            actions: actions,
            centerTitle: centerTitle,
            backgroundColor: Colors.transparent,
            foregroundColor: resolvedColor,
            elevation: elevation,
            scrolledUnderElevation: 0,
            bottom: bottom,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
