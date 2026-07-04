import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable Checkbox form component with label text.
class UICheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;

  const UICheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActiveColor =
        activeColor ?? Theme.of(context).colorScheme.primary;

    // Inactive border color
    final Color inactiveBorderColor = isDark ? Colors.white30 : Colors.black26;

    return UIBounceable(
      scaleFactor: 0.98,
      onTap: () => onChanged(!value),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom Animated Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 22.0,
              height: 22.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: value ? resolvedActiveColor : inactiveBorderColor,
                  width: 2.0,
                ),
                color: value ? resolvedActiveColor : Colors.transparent,
              ),
              child: AnimatedScale(
                scale: value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.elasticOut,
                child: const Icon(
                  Icons.check,
                  size: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              label,
              style: UITypography.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: value ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
