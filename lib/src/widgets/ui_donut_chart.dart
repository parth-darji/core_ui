import 'dart:math';
import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Segment details for the Donut Chart.
class UIDonutSegment {
  final double percentage; // Value between 0.0 and 1.0
  final Color color;
  final String label;

  const UIDonutSegment({
    required this.percentage,
    required this.color,
    required this.label,
  });
}

/// Reusable dynamic Donut Chart widget with custom center text and entry animations.
class UIDonutChart extends StatefulWidget {
  final List<UIDonutSegment> segments;
  final double width;
  final double height;
  final String? centerTitle;
  final String? centerSubtitle;
  final double thickness;

  const UIDonutChart({
    super.key,
    required this.segments,
    this.width = 200.0,
    this.height = 200.0,
    this.centerTitle,
    this.centerSubtitle,
    this.thickness = 24.0,
  });

  @override
  State<UIDonutChart> createState() => _UIDonutChartState();
}

class _UIDonutChartState extends State<UIDonutChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UIDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.segments != widget.segments) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _DonutPainter(
                  segments: widget.segments,
                  thickness: widget.thickness,
                  animationValue: _animation.value,
                ),
              );
            },
          ),
          if (widget.centerTitle != null || widget.centerSubtitle != null)
            SizedBox(
              width: max(
                0.0,
                min(widget.width, widget.height) - widget.thickness * 2 - 8.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.centerTitle != null)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.centerTitle!,
                        style: UITypography.displaySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  if (widget.centerSubtitle != null) ...[
                    const SizedBox(height: 2.0),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.centerSubtitle!,
                        style: UITypography.labelSmall,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<UIDonutSegment> segments;
  final double thickness;
  final double animationValue;

  _DonutPainter({
    required this.segments,
    required this.thickness,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (min(size.width, size.height) - thickness) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    double startAngle = -pi / 2; // Start drawing from 12 o'clock

    // Introduce a subtle visual gap (0.04 radians ~ 2.3 degrees) between segments for a floating premium design
    final activeSegments = segments.where((s) => s.percentage > 0.0).toList();
    final double gapAngle = activeSegments.length > 1 ? 0.04 : 0.0;
    final double totalGaps = activeSegments.length * gapAngle;
    final double availableAngle = 2 * pi - totalGaps;

    final double capAngle = thickness / radius;

    for (final segment in segments) {
      if (segment.percentage <= 0.0) continue;
      final double visualAngle =
          segment.percentage * availableAngle * animationValue;

      // Subtract cap angle to prevent overlapping round caps from eating each other's visual space
      final double sweepAngle = max(0.0, visualAngle - capAngle);
      final double drawStartAngle = startAngle + (capAngle / 2);

      paint.color = segment.color;

      canvas.drawArc(rect, drawStartAngle, sweepAngle, false, paint);
      startAngle += visualAngle + (gapAngle * animationValue);
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.thickness != thickness ||
        oldDelegate.animationValue != animationValue;
  }
}
