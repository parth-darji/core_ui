import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Filter Chip widget for sorting/filtering.
class UIFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final Widget? avatar;

  const UIFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedSelectedBg = Theme.of(context).colorScheme.primary;
    final resolvedUnselectedBg =
        isDark ? const Color(0xFF222222) : const Color(0xFFF0F3F3);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      avatar: avatar,
      labelStyle: UITypography.bodySmall.copyWith(
        color:
            isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: resolvedUnselectedBg,
      selectedColor: resolvedSelectedBg,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: isSelected ? resolvedSelectedBg : Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
    );
  }
}
