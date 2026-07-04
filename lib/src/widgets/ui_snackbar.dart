import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Snackbar builder styled with design system tokens.
class UISnackbar {
  UISnackbar._();

  /// Triggers a toast/snackbar message in context.
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg = isError
        ? Theme.of(context).colorScheme.error
        : (isDark
            ? const Color(0xFF2A2A2A)
            : Theme.of(context).colorScheme.primary);
    final resolvedFg = Colors.white;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: UITypography.bodyMedium.copyWith(
            color: resolvedFg,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: resolvedBg,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: isError
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }
}
