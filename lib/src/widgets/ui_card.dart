import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import 'ui_bounceable.dart';

/// Card types supported by standard Material 3 specifications.
enum UICardType {
  elevated,
  filled,
  outlined,
}

/// Reusable Card component supporting filled, elevated and outlined configurations.
class UICard extends StatelessWidget {
  final Widget child;
  final UICardType type;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final VoidCallback? onTap;

  const UICard({
    super.key,
    required this.child,
    this.type = UICardType.filled,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16.0,
    this.onTap,
  });

  /// Factory constructor for elevated card variation.
  const UICard.elevated({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.backgroundColor,
    this.borderRadius = 16.0,
    this.onTap,
  })  : type = UICardType.elevated,
        borderColor = null;

  /// Factory constructor for filled card variation.
  const UICard.filled({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.backgroundColor,
    this.borderRadius = 16.0,
    this.onTap,
  })  : type = UICardType.filled,
        borderColor = null;

  /// Factory constructor for outlined card variation.
  const UICard.outlined({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16.0,
    this.onTap,
  }) : type = UICardType.outlined;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve visual options dynamically matching design system tokens
    Color resolvedBg;
    BoxBorder? resolvedBorder;
    List<BoxShadow>? resolvedShadow;

    switch (type) {
      case UICardType.elevated:
        resolvedBg = backgroundColor ??
            (isDark ? const Color(0xFF1E1E1E) : UIColors.cardBackground);
        resolvedShadow = isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12.0,
                  offset: const Offset(0, 4),
                )
              ];
        break;
      case UICardType.filled:
        resolvedBg = backgroundColor ??
            (isDark ? const Color(0xFF252525) : const Color(0xFFF4F6F6));
        break;
      case UICardType.outlined:
        resolvedBg = backgroundColor ??
            (isDark ? Colors.transparent : UIColors.cardBackground);
        resolvedBorder = Border.all(
          color: borderColor ??
              (isDark ? const Color(0xFF333333) : UIColors.separator),
          width: 1.0,
        );
        break;
    }

    final cardContainer = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: resolvedBorder,
        boxShadow: resolvedShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: UIBounceable(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    return cardContainer;
  }
}
