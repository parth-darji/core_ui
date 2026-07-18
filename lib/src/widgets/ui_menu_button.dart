import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

class UIMenuItem<T> {
  final T value;
  final String label;
  final IconData icon;
  final bool isDestructive;

  const UIMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.isDestructive = false,
  });
}

class UIMenuButton<T> extends StatelessWidget {
  final List<UIMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final Widget? icon;
  final String? tooltip;

  const UIMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopupMenuButton<T>(
      tooltip: tooltip ?? 'Options',
      icon: icon ?? Icon(Icons.more_vert_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          final color = item.isDestructive
              ? theme.colorScheme.error
              : theme.colorScheme.onSurface;
          final iconColor = item.isDestructive
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant;

          return PopupMenuItem<T>(
            value: item.value,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: item.isDestructive
                        ? theme.colorScheme.error.withValues(alpha: 0.08)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    size: 16,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: UITypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
