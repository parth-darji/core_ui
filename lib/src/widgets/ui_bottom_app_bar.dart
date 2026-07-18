import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';

/// Reusable Bottom App Bar containing child widget action buttons.
class UIBottomAppBar extends StatelessWidget {
  final List<Widget> children;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final double elevation;
  final double? height;

  const UIBottomAppBar({
    super.key,
    required this.children,
    this.floatingActionButton,
    this.backgroundColor,
    this.elevation = 8.0,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg = backgroundColor ??
        (isDark ? const Color(0xFF1A1A1A) : UIColors.cardBackground);

    return Container(
      decoration: BoxDecoration(
        color: resolvedBg,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: elevation,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height ?? 60.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      ),
    );
  }
}
