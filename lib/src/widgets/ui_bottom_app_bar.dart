import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';

/// Reusable Bottom App Bar containing child widget action buttons.
class UIBottomAppBar extends StatelessWidget {
  final List<Widget> children;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final double elevation;

  const UIBottomAppBar({
    super.key,
    required this.children,
    this.floatingActionButton,
    this.backgroundColor,
    this.elevation = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg = backgroundColor ??
        (isDark ? const Color(0xFF1A1A1A) : UIColors.cardBackground);

    return BottomAppBar(
      color: resolvedBg,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      shape: const CircularNotchedRectangle(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...children,
              if (floatingActionButton != null) ...[
                const Spacer(),
                floatingActionButton!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
