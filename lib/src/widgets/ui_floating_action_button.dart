import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable Floating Action Button (FAB) configured with M3 standard sizes and premium bounce feedback.
class UIFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExtended;

  const UIFloatingActionButton({
    super.key,
    required this.icon,
    this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  }) : isExtended = label != null;

  @override
  Widget build(BuildContext context) {
    final defaultBg = Theme.of(context).colorScheme.primary;
    final defaultFg = Theme.of(context).colorScheme.onPrimary;

    final resolvedBg = backgroundColor ?? defaultBg;
    final resolvedFg = foregroundColor ?? defaultFg;

    final fab = isExtended
        ? FloatingActionButton.extended(
            onPressed: () {}, // dummy callback to keep active styles
            backgroundColor: resolvedBg,
            foregroundColor: resolvedFg,
            icon: icon,
            label: Text(
              label!,
              style: UITypography.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: resolvedFg,
              ),
            ),
          )
        : FloatingActionButton(
            onPressed: () {}, // dummy callback to keep active styles
            backgroundColor: resolvedBg,
            foregroundColor: resolvedFg,
            child: icon,
          );

    return UIBounceable(
      onTap: onPressed,
      child: fab,
    );
  }
}
