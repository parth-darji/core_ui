import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Linear Progress Bar with optional value/percentage labels.
class UIProgressBar extends StatelessWidget {
  final double value; // Between 0.0 and 1.0
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final String? label;
  final String? trailingLabel;

  const UIProgressBar({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = 8.0,
    this.label,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    final resolvedBg = backgroundColor ??
        (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null || trailingLabel != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: UITypography.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                if (trailingLabel != null)
                  Text(
                    trailingLabel!,
                    style: UITypography.labelSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6.0),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: Container(
              height: height,
              width: double.infinity,
              color: resolvedBg,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  width: MediaQuery.of(context).size.width *
                      (value.clamp(0.0, 1.0)),
                  height: height,
                  color: resolvedColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
