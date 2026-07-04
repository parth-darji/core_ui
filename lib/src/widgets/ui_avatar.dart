import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_media_viewer.dart';

/// Reusable circular profile avatar.
class UIAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? fallbackIcon;

  const UIAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 20.0,
    this.backgroundColor,
    this.textColor,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E6E6);
    final defaultFg = Theme.of(context).colorScheme.primary;

    final resolvedBg = backgroundColor ?? defaultBg;
    final resolvedFg = textColor ?? defaultFg;

    Widget content;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = ClipOval(
        child: UIMediaViewer(
          source: imageUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    } else if (initials != null && initials!.isNotEmpty) {
      content = Text(
        initials!.toUpperCase(),
        style: UITypography.titleMedium.copyWith(
          color: resolvedFg,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      );
    } else {
      content =
          fallbackIcon ?? Icon(Icons.person, color: resolvedFg, size: radius);
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: resolvedBg,
        shape: BoxShape.circle,
      ),
      child: Center(child: content),
    );
  }
}
