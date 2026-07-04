import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable Radio Group component.
class UIRadioGroup<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) labelBuilder;
  final T selectedOption;
  final ValueChanged<T> onSelected;
  final Color? activeColor;

  const UIRadioGroup({
    super.key,
    required this.options,
    required this.labelBuilder,
    required this.selectedOption,
    required this.onSelected,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActiveColor =
        activeColor ?? Theme.of(context).colorScheme.primary;
    final Color inactiveBorderColor = isDark ? Colors.white30 : Colors.black26;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        options.length,
        (index) {
          final option = options[index];
          final isSelected = option == selectedOption;

          return UIBounceable(
            scaleFactor: 0.98,
            onTap: () => onSelected(option),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.transparent,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  // Custom Animated Radio Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    width: 22.0,
                    height: 22.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? resolvedActiveColor
                            : inactiveBorderColor,
                        width: 2.0,
                      ),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        scale: isSelected ? 1.0 : 0.0,
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: resolvedActiveColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    labelBuilder(option),
                    style: UITypography.bodyLarge.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
