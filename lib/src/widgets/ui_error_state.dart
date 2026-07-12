import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_filled_button.dart';

/// Reusable Error State view styled with design system tokens.
class UIErrorState extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const UIErrorState({
    super.key,
    this.title = 'An error occurred',
    required this.message,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 16.0),
            ] else ...[
              Icon(
                Icons.error_outline_rounded,
                size: 64.0,
                color: isDark ? Colors.redAccent : Colors.red,
              ),
              const SizedBox(height: 16.0),
            ],
            Text(
              title,
              style: UITypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: UITypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24.0),
              UIFilledButton(
                text: actionLabel!,
                height: 44.0,
                borderRadius: 12.0,
                onPressed: onActionPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
