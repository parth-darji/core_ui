import 'package:flutter/material.dart';

/// Reusable Page Dot Indicator for carousels and sliders.
class UIPageIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  final Color? activeColor;
  final Color? inactiveColor;

  const UIPageIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActive = activeColor ?? Theme.of(context).colorScheme.primary;
    final resolvedInactive =
        inactiveColor ?? (isDark ? Colors.white24 : Colors.black12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) {
          final isActive = index == activeIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: isActive ? 16.0 : 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: isActive ? resolvedActive : resolvedInactive,
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        },
      ),
    );
  }
}
