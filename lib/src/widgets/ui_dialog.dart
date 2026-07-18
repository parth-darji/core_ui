import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import '../tokens/ui_typography.dart';
import 'ui_filled_button.dart';
import 'ui_text_button.dart';

/// Reusable Material 3 Dialog styled with design system tokens.
class UIDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final Widget? icon;

  const UIDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel,
    this.onCancel,
    this.icon,
  });

  /// Helper to trigger dialog natively in context
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    required String confirmLabel,
    required VoidCallback onConfirm,
    String? cancelLabel,
    VoidCallback? onCancel,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'UIDialog',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: UIDialog(
            title: title,
            message: message,
            content: content,
            confirmLabel: confirmLabel,
            onConfirm: onConfirm,
            cancelLabel: cancelLabel,
            onCancel: onCancel,
            icon: icon,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return Stack(
          children: [
            // Smoothly animated backdrop blur and dim overlay (painted directly on screen)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    final curvedValue =
                        Curves.easeOut.transform(animation.value);
                    final sigma = curvedValue * 6.0;
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                      child: Container(
                        color:
                            Colors.black.withValues(alpha: curvedValue * 0.35),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Dialog card fades and scales on top of the smooth backdrop
            FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0)
                    .animate(curvedAnimation),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg =
        isDark ? const Color(0xFF1E1E1E) : UIColors.cardBackground;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500.0),
        child: AlertDialog(
          backgroundColor: resolvedBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          icon: icon,
          title: Text(
            title,
            style: UITypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: content ?? (message != null ? Text(
            message!,
            style: UITypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ) : null),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding:
              const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
          actions: [
            if (cancelLabel != null)
              UITextButton(
                text: cancelLabel!,
                onPressed: () {
                  Navigator.pop(context);
                  onCancel?.call();
                },
                textColor: Colors.grey.shade600,
              ),
            UIFilledButton(
              text: confirmLabel,
              height: 44.0,
              borderRadius: 12.0,
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
            ),
          ],
        ),
      ),
    );
  }
}
