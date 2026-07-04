import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable status tag / informational badge.
class UIBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isRound;
  final double paddingHorizontal;
  final double paddingVertical;

  const UIBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.isRound = false,
    this.paddingHorizontal = 10.0,
    this.paddingVertical = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBg =
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);
    final defaultFg = Theme.of(context).colorScheme.primary;

    final resolvedBg = backgroundColor ?? defaultBg;
    final resolvedFg = textColor ?? defaultFg;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(isRound ? 100.0 : 8.0),
      ),
      child: Text(
        text,
        style: UITypography.labelSmall.copyWith(
          color: resolvedFg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
