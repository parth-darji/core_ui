import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Cupertino-style Text Button that animates its scale on press and triggers haptics.
class UITextButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? prefix;
  final Widget? suffix;
  final Color? textColor;
  final TextStyle? textStyle;

  const UITextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefix,
    this.suffix,
    this.textColor,
    this.textStyle,
  });

  @override
  State<UITextButton> createState() => _UITextButtonState();
}

class _UITextButtonState extends State<UITextButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final resolvedFg = widget.textColor ?? Theme.of(context).colorScheme.primary;
    final isInteractive = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isInteractive ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isInteractive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isInteractive ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: isInteractive 
            ? (_isPressed ? 0.4 : 1.0) 
            : 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.prefix != null) ...[
                widget.prefix!,
                const SizedBox(width: 6.0),
              ],
              Text(
                widget.text,
                style: (widget.textStyle ?? UITypography.bodyLarge).copyWith(
                  color: isInteractive ? resolvedFg : Colors.grey.shade400,
                  fontWeight: widget.textStyle?.fontWeight ?? FontWeight.w600,
                ),
              ),
              if (widget.suffix != null) ...[
                const SizedBox(width: 6.0),
                widget.suffix!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
