import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';

/// A premium, beautiful custom divider widget.
/// It features a crisp, clean horizontal divider line.
class UIDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  const UIDivider({
    super.key,
    this.height = 16.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = (color == null || color == UIColors.separator)
        ? (isDark ? Colors.white12 : UIColors.separator)
        : color!;

    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: Container(
          height: thickness,
          color: baseColor,
        ),
      ),
    );
  }
}
