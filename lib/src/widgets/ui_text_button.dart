import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable Cupertino-style Text Button that animates its scale on press and triggers haptics.
class UITextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? prefix;
  final Widget? suffix;
  final Color? textColor;

  const UITextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefix,
    this.suffix,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedFg = textColor ?? Theme.of(context).colorScheme.primary;
    final isInteractive = onPressed != null;

    return UIBounceable(
      onTap: onPressed,
      scaleFactor: 0.96,
      child: Opacity(
        opacity: isInteractive ? 1.0 : 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefix != null) ...[
                prefix!,
                const SizedBox(width: 6.0),
              ],
              Text(
                text,
                style: UITypography.bodyLarge.copyWith(
                  color: isInteractive ? resolvedFg : Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 6.0),
                suffix!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
