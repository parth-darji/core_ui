import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable capsule sliding Segment Control.
class UISegmentControl extends StatelessWidget implements PreferredSizeWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onValueChanged;
  final Color? backgroundColor;
  final Color? activeColor;

  const UISegmentControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onValueChanged,
    this.backgroundColor,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg = backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFEAEAEA));
    final resolvedActive = activeColor ?? Theme.of(context).colorScheme.primary;
    final activeTextColor = ThemeData.estimateBrightnessForColor(resolvedActive) == Brightness.dark
        ? Colors.white
        : const Color(0xFF1E1E1E);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // Padding is 4.0 on left and right, so total padding is 8.0
        final availableWidth = (totalWidth - 8.0).clamp(0.0, double.infinity);
        final segmentWidth = availableWidth / segments.length;

        return Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: resolvedBg,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Stack(
            children: [
              // Sliding Active Indicator Card
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic, // Smoother and faster transition
                left: selectedIndex * segmentWidth,
                top: 0.0,
                bottom: 0.0,
                width: segmentWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: resolvedActive,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: resolvedActive.withOpacity(0.25),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Interactive Text Segments Row
              Row(
                children: List.generate(
                  segments.length,
                  (index) {
                    final isSelected = index == selectedIndex;
                    return Expanded(
                      child: UIBounceable(
                        scaleFactor: 0.96,
                        onTap: () => onValueChanged(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          alignment: Alignment.center,
                          color: Colors
                              .transparent, // Keeps entire area interactive
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: UITypography.labelLarge.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? activeTextColor
                                  : (isDark ? Colors.white60 : Colors.black54),
                            ),
                            child: Text(
                              segments[index],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
