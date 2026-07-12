import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable Material 3 Outlined Button matching design system color tokens.
class UIOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? prefix;
  final Widget? suffix;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;
  final double borderRadius;
  final double height;

  const UIOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefix,
    this.suffix,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
    this.borderRadius = 16.0,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = Theme.of(context).colorScheme.primary;

    final resolvedBorderColor = borderColor ?? defaultColor;
    final resolvedTextColor = textColor ?? resolvedBorderColor;

    final isInteractive = !isLoading && onPressed != null;

    final borderPaintColor = isInteractive
        ? resolvedBorderColor
        : (isDark ? Colors.white24 : Colors.grey.shade400);

    final contentColor = isInteractive
        ? resolvedTextColor
        : (isDark ? Colors.white38 : Colors.grey.shade500);

    return UIBounceable(
      onTap: isInteractive ? onPressed : null,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderPaintColor, width: 1.5),
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
