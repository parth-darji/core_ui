import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable PIN / OTP code input display with support for error state and shake animations.
class UIPinCodeField extends StatefulWidget {
  final String pin;
  final int length;
  final bool obscure;
  final bool hasError;
  final String? errorText;

  const UIPinCodeField({
    super.key,
    required this.pin,
    this.length = 4,
    this.obscure = true,
    this.hasError = false,
    this.errorText,
  });

  @override
  State<UIPinCodeField> createState() => _UIPinCodeFieldState();
}

class _UIPinCodeFieldState extends State<UIPinCodeField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );

    // Creates a horizontal shake animation (back and forth 3 times)
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 6.0, end: -3.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -3.0, end: 3.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 3.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    if (widget.hasError) {
      _shakeController.forward();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UIPinCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger shake animation when hasError transitions from false to true
    if (widget.hasError && !oldWidget.hasError) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = Theme.of(context).colorScheme.error;

    final dotColor = widget.hasError
        ? errorColor
        : (isDark ? Colors.white70 : Theme.of(context).colorScheme.primary);
    final boxBg = isDark ? const Color(0xFF222222) : const Color(0xFFF4F6F6);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0.0),
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.length,
              (index) {
                final hasValue = index < widget.pin.length;
                final isActive = index == widget.pin.length;
                Widget displayWidget;

                if (hasValue) {
                  if (widget.obscure) {
                    displayWidget = Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    );
                  } else {
                    displayWidget = Text(
                      widget.pin[index],
                      style: UITypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.hasError
                            ? errorColor
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  }
                } else {
                  displayWidget = const SizedBox.shrink();
                }

                Color borderColor;
                double borderWidth;

                if (widget.hasError) {
                  borderColor = errorColor;
                  borderWidth = 2.0;
                } else if (isActive) {
                  borderColor = Theme.of(context).colorScheme.primary;
                  borderWidth = 2.0;
                } else if (hasValue) {
                  borderColor = isDark ? Colors.white54 : Colors.black38;
                  borderWidth = 1.5;
                } else {
                  borderColor = isDark ? Colors.white10 : Colors.grey.shade300;
                  borderWidth = 1.0;
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 50.0,
                  height: 50.0,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: displayWidget,
                );
              },
            ),
          ),
        ),
        if (widget.errorText != null && widget.hasError) ...[
          const SizedBox(height: 8.0),
          Text(
            widget.errorText!,
            style: UITypography.bodySmall.copyWith(
              color: errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
