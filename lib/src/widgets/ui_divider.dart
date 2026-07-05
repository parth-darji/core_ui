import 'package:flutter/material.dart';

/// A premium, beautiful custom divider widget.
/// It features a soft horizontal color gradient that fades out at the edges
/// combined with a subtle glowing/blurred light accent shadow behind it.
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
    
    // Choose soft glowing light colors for the gradient
    final baseColor = color ?? (isDark ? Colors.white24 : Colors.black12);
    final glowColor = isDark 
        ? theme.colorScheme.primary.withValues(alpha: 0.2)
        : theme.colorScheme.primary.withValues(alpha: 0.1);

    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft glowing backdrop blur container
            Container(
              height: thickness * 4.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(thickness * 2.0),
                gradient: LinearGradient(
                  colors: [
                    glowColor.withValues(alpha: 0.0),
                    glowColor,
                    glowColor.withValues(alpha: 0.0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
            // The precise, razor-sharp gradient divider line
            Container(
              height: thickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    baseColor.withValues(alpha: 0.0),
                    baseColor,
                    baseColor.withValues(alpha: 0.0),
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
