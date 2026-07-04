import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable interactive numeric keypad widget with springy key presses and haptics.
class UINumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;
  final Color? buttonColor;
  final Color? textColor;

  const UINumericKeypad({
    super.key,
    required this.onKeyPress,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedButtonColor = buttonColor ??
        (isDark ? const Color(0xFF222222) : const Color(0xFFF4F6F6));
    final resolvedTextColor =
        textColor ?? Theme.of(context).colorScheme.primary;

    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];

    return Table(
      children: [
        for (final row in keys)
          TableRow(
            children: [
              for (final val in row)
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: UIBounceable(
                      scaleFactor: 0.92,
                      hapticType:
                          val == '⌫' ? UIHapticType.medium : UIHapticType.light,
                      onTap: () => onKeyPress(val),
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: resolvedButtonColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: val == '⌫'
                              ? Icon(Icons.backspace_outlined,
                                  color: resolvedTextColor, size: 18.0)
                              : Text(
                                  val,
                                  style: UITypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: resolvedTextColor,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
