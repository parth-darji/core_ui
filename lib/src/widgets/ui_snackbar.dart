import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import '../tokens/ui_typography.dart';

/// Reusable Snackbar builder styled with design system tokens.
class UISnackbar {
  UISnackbar._();

  /// Triggers a toast/snackbar message in context.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    String? errorCode,
    bool isError = false,
    bool isSuccess = false,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String? resolvedErrorCode = errorCode;
    if (isError && resolvedErrorCode == null) {
      final msg = message.toLowerCase();
      if (msg.contains('401') || msg.contains('unauthorized') || msg.contains('invalid email')) {
        resolvedErrorCode = 'ERR-401';
      } else if (msg.contains('409') || msg.contains('conflict') || msg.contains('registered')) {
        resolvedErrorCode = 'ERR-409';
      } else if (msg.contains('403') || msg.contains('forbidden')) {
        resolvedErrorCode = 'ERR-403';
      } else if (msg.contains('404') || msg.contains('not found')) {
        resolvedErrorCode = 'ERR-404';
      } else if (msg.contains('timeout') || msg.contains('connection') || msg.contains('refused') || msg.contains('socket')) {
        resolvedErrorCode = 'ERR-CONN';
      } else {
        resolvedErrorCode = 'ERR-UNKNOWN';
      }
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        duration: duration,
        content: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isError
                    ? (isDark
                        ? const Color(0xFF2C1616)
                        : const Color(0xFFFFF5F5))
                    : isSuccess
                        ? (isDark
                            ? const Color(0xFF142C14)
                            : const Color(0xFFF4FBF4))
                        : (isDark
                            ? const Color(0xFF1E293B)
                            : UIColors.systemBackground),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isError
                      ? UIColors.lotusRose.withValues(alpha: 0.4)
                      : isSuccess
                          ? Colors.green.withValues(alpha: 0.4)
                          : theme.colorScheme.primary.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isError
                          ? UIColors.lotusRose.withValues(alpha: 0.15)
                          : isSuccess
                              ? Colors.green.withValues(alpha: 0.15)
                              : theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isError
                          ? Icons.error_outline_rounded
                          : isSuccess
                              ? Icons.check_circle_outline_rounded
                              : Icons.info_outline_rounded,
                      color: isError
                          ? UIColors.lotusRose
                          : isSuccess
                              ? Colors.green
                              : theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title ?? (isError
                              ? (resolvedErrorCode != null ? 'Error (Code: $resolvedErrorCode)' : 'Error')
                              : isSuccess
                                  ? 'Success'
                                  : 'Notice'),
                          style: UITypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isError
                                ? (isDark ? Colors.white : const Color(0xFFC62828))
                                : isSuccess
                                    ? (isDark ? Colors.white : const Color(0xFF2E7D32))
                                    : (isDark ? Colors.white : UIColors.textPrimary),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: UITypography.bodySmall.copyWith(
                            color: isError
                                ? (isDark ? UIColors.lotusRose : const Color(0xFFB71C1C))
                                : isSuccess
                                    ? (isDark ? Colors.green[200] : const Color(0xFF1B5E20))
                                    : (isDark ? Colors.grey[300] : UIColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (actionLabel != null && onActionPressed != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        onActionPressed();
                      },
                      child: Text(
                        actionLabel,
                        style: UITypography.bodyMedium.copyWith(
                          color: isError
                              ? Colors.white
                              : theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
