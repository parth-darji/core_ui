import 'dart:ui';
import 'package:flutter/material.dart';
import 'ui_bounceable.dart';
import '../tokens/ui_typography.dart';

/// A custom ShapeBorder that draws a speech-bubble bubble shape with a pointing caret (arrow).
/// The caret can be drawn either at the top pointing up, or at the bottom pointing down.
class TooltipShapeBorder extends ShapeBorder {
  final double caretX;
  final double caretSize;
  final double borderRadius;
  final bool arrowAtTop;

  const TooltipShapeBorder({
    required this.caretX,
    this.caretSize = 10.0,
    this.borderRadius = 12.0,
    required this.arrowAtTop,
  });

  @override
  EdgeInsetsGeometry get dimensions {
    return arrowAtTop
        ? EdgeInsets.only(top: caretSize)
        : EdgeInsets.only(bottom: caretSize);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final r = borderRadius;

    if (arrowAtTop) {
      final topLimit = rect.top + caretSize;

      // Start top-left
      path.moveTo(rect.left + r, topLimit);

      // Top side with caret pointing up
      path.lineTo(rect.left + caretX - caretSize, topLimit);
      path.lineTo(rect.left + caretX, rect.top);
      path.lineTo(rect.left + caretX + caretSize, topLimit);

      path.lineTo(rect.right - r, topLimit);
      path.quadraticBezierTo(rect.right, topLimit, rect.right, topLimit + r);

      // Right side
      path.lineTo(rect.right, rect.bottom - r);
      path.quadraticBezierTo(
          rect.right, rect.bottom, rect.right - r, rect.bottom);

      // Bottom side
      path.lineTo(rect.left + r, rect.bottom);
      path.quadraticBezierTo(
          rect.left, rect.bottom, rect.left, rect.bottom - r);

      // Left side
      path.lineTo(rect.left, topLimit + r);
      path.quadraticBezierTo(rect.left, topLimit, rect.left + r, topLimit);
    } else {
      final bottomLimit = rect.bottom - caretSize;

      // Start top-left
      path.moveTo(rect.left + r, rect.top);
      path.lineTo(rect.right - r, rect.top);
      path.quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + r);

      // Right side
      path.lineTo(rect.right, bottomLimit - r);
      path.quadraticBezierTo(
          rect.right, bottomLimit, rect.right - r, bottomLimit);

      // Bottom side with caret pointing down
      path.lineTo(rect.left + caretX + caretSize, bottomLimit);
      path.lineTo(rect.left + caretX, rect.bottom);
      path.lineTo(rect.left + caretX - caretSize, bottomLimit);

      path.lineTo(rect.left + r, bottomLimit);
      path.quadraticBezierTo(
          rect.left, bottomLimit, rect.left, bottomLimit - r);

      // Left side
      path.lineTo(rect.left, rect.top + r);
      path.quadraticBezierTo(rect.left, rect.top, rect.left + r, rect.top);
    }

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

/// A custom clipper that subtracts a rounded rectangle (representing a hole)
/// from a fullscreen rectangle, leaving a window of clean focus.
class HoleClipper extends CustomClipper<Path> {
  final Rect holeRect;
  final double borderRadius;

  const HoleClipper({
    required this.holeRect,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path();
    holePath.addRRect(
      RRect.fromRectAndRadius(
        holeRect,
        Radius.circular(borderRadius),
      ),
    );

    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(HoleClipper oldClipper) =>
      holeRect != oldClipper.holeRect ||
      borderRadius != oldClipper.borderRadius;
}

/// A custom premium Tooltip / Info Popover widget that shows message details
/// inside an aligned modal bubble card with a blurred system backdrop barrier.
class UITooltipInfo extends StatelessWidget {
  final Widget child;
  final String message;
  final String? title;

  const UITooltipInfo({
    super.key,
    required this.child,
    required this.message,
    this.title,
  });

  void _showTooltip(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'TooltipInfo',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final screenHeight = mediaQuery.size.height;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final resolvedBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;

        // Position calculations
        final triggerCenterX = offset.dx + size.width / 2;

        // Tooltip card width
        const tooltipWidth = 280.0;
        const caretSize = 10.0;

        // Auto-detect whether to show above or below the trigger
        final arrowAtTop = offset.dy < 180.0;

        // Calculate X coordinate
        double left = triggerCenterX - (tooltipWidth / 2);
        if (left < 16.0) left = 16.0;
        if (left + tooltipWidth > screenWidth - 16.0) {
          left = screenWidth - 16.0 - tooltipWidth;
        }

        // Caret horizontal position relative to the tooltip card
        final localCaretX = triggerCenterX - left;
        final clampedCaretX = localCaretX.clamp(16.0, tooltipWidth - 16.0);

        // Position coordinates
        double? top;
        double? bottom;

        if (arrowAtTop) {
          top = offset.dy + size.height + 6.0;
        } else {
          bottom = screenHeight - offset.dy + 6.0;
        }

        // Visual alignment mapping (scales exactly out of the caret pointer tip)
        final scaleAlignment = Alignment(
          (clampedCaretX / (tooltipWidth / 2)) - 1.0,
          arrowAtTop ? -1.0 : 1.0,
        );

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return Stack(
          children: [
            // Fullscreen translucent gesture detector to dismiss tooltip on tapping outside
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),

            // Tooltip body popover scaled from the caret tip
            Positioned(
              left: left,
              width: tooltipWidth,
              top: top,
              bottom: bottom,
              child: GestureDetector(
                onTap:
                    () {}, // Consume taps inside the tooltip so it doesn't dismiss
                child: ScaleTransition(
                  alignment: scaleAlignment,
                  scale: Tween<double>(begin: 0.5, end: 1.0)
                      .animate(curvedAnimation),
                  child: Material(
                    color: resolvedBg,
                    elevation: 6.0,
                    shadowColor: Colors.black.withValues(alpha: 0.2),
                    shape: TooltipShapeBorder(
                      caretX: clampedCaretX,
                      caretSize: caretSize,
                      borderRadius: 12.0,
                      arrowAtTop: arrowAtTop,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null) ...[
                            Text(
                              title!,
                              style: UITypography.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                          ],
                          Text(
                            message,
                            style: UITypography.bodyMedium.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const paddingX = 8.0;
        const paddingY = 4.0;
        final holeRect = Rect.fromLTWH(
          offset.dx - paddingX,
          offset.dy - paddingY,
          size.width + (paddingX * 2),
          size.height + (paddingY * 2),
        );
        final holeRadius =
            (size.width - size.height).abs() < 2.0 ? holeRect.width / 2 : 10.0;

        return Stack(
          children: [
            // BackdropFilter is NOT inside FadeTransition, so it renders directly on the screen
            // and its blur is animated smoothly by AnimatedBuilder / rebuilds.
            Positioned.fill(
              child: ClipPath(
                clipper: HoleClipper(
                  holeRect: holeRect,
                  borderRadius: holeRadius,
                ),
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) {
                      final curvedValue =
                          Curves.easeOut.transform(animation.value);
                      final sigma = curvedValue * 6.0;
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                        child: Container(
                          color:
                              Colors.black.withValues(alpha: curvedValue * 0.3),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Only the tooltip popover and general tap dismiss detector are faded in/out
            FadeTransition(
              opacity: animation,
              child: child,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIBounceable(
      onTap: () => _showTooltip(context),
      child: child,
    );
  }
}
