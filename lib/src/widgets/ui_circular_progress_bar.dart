import 'dart:math';
import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Circular Progress Ring tracker.
class UICircularProgressBar extends StatelessWidget {
  final double value; // Value between 0.0 and 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final String? centerText;

  const UICircularProgressBar({
    super.key,
    required this.value,
    this.size = 80.0,
    this.strokeWidth = 8.0,
    this.color,
    this.backgroundColor,
    this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    final resolvedBg = backgroundColor ??
        (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB));

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              value: value.clamp(0.0, 1.0),
              color: resolvedColor,
              backgroundColor: resolvedBg,
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerText != null)
            Text(
              centerText!,
              style: UITypography.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: size * 0.18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.value,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (min(size.width, size.height) - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background track
    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = backgroundColor
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius, trackPaint);

    // Draw active progress arc
    if (value > 0.0) {
      final Paint progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = color
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      canvas.drawArc(rect, -pi / 2, value * 2 * pi, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
