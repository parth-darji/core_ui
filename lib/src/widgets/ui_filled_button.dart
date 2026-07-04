import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable Material 3 Filled Button matching design system color tokens.
class UIFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? prefix;
  final Widget? suffix;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double height;

  const UIFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefix,
    this.suffix,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 16.0,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = Theme.of(context).colorScheme.primary;
    final defaultFg = Theme.of(context).colorScheme.onPrimary;

    final resolvedBg = backgroundColor ?? defaultBg;
    final resolvedFg = textColor ?? defaultFg;

    final isInteractive = !isLoading && onPressed != null;

    final containerBg = isInteractive
        ? resolvedBg
        : (isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade300);

    final contentColor = isInteractive
        ? resolvedFg
        : (isDark ? Colors.white38 : Colors.grey.shade500);

    return UIBounceable(
      onTap: isInteractive ? onPressed : null,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefix != null) ...[
                      prefix!,
                      const SizedBox(width: 8.0),
                    ],
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: UITypography.titleMedium.copyWith(
                          color: contentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (suffix != null) ...[
                      const SizedBox(width: 8.0),
                      suffix!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
