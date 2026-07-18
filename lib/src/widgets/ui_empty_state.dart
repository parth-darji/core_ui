import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_filled_button.dart';

/// Reusable Empty State view styled with design system tokens.
class UIEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const UIEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
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
              const Icon(
                Icons.inbox_outlined,
                size: 64.0,
                color: Colors.grey,
              ),
              const SizedBox(height: 16.0),
            ],
            Text(
              title,
              style: UITypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: UITypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24.0),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: UIFilledButton(
                  text: actionLabel!,
                  height: 44.0,
                  borderRadius: 12.0,
                  onPressed: onActionPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
