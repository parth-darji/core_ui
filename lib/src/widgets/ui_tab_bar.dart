import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable Tab Bar header widget with animated selection underline indicator.
class UITabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color? activeColor;
  final Color? inactiveColor;

  const UITabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActive = activeColor ?? Theme.of(context).colorScheme.primary;
    final resolvedInactive =
        inactiveColor ?? (isDark ? Colors.white30 : Colors.black38);

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: UIColors.separator,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          tabs.length,
          (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: UIBounceable(
                scaleFactor: 0.95,
                hapticType: UIHapticType.selection,
                onTap: () => onTabSelected(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        tabs[index],
                        style: UITypography.labelLarge.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? resolvedActive : resolvedInactive,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 3.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? resolvedActive : Colors.transparent,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
