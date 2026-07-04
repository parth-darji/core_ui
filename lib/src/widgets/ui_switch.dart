import 'package:flutter/material.dart';
import 'ui_bounceable.dart';

/// Reusable custom sliding toggle switch styled with design system tokens.
class UISwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const UISwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActiveColor =
        activeColor ?? Theme.of(context).colorScheme.primary;

    final Color trackBg = value
        ? (onChanged == null
            // ignore: deprecated_member_use
            ? resolvedActiveColor.withOpacity(0.5)
            : resolvedActiveColor)
        : (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE0E0E0));

    return UIBounceable(
      scaleFactor: 0.95,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 50.0,
        height: 28.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: trackBg,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack, // Playful slide feel
              left: value ? 26.0 : 4.0,
              top: 4.0,
              bottom: 4.0,
              width: 20.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 2.0,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
