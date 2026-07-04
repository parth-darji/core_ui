import 'dart:math';
import 'package:flutter/material.dart';

/// Reusable Sparkline / Line Chart component to visualize trends with entry animations.
class UILineChart extends StatefulWidget {
  final List<double> dataPoints;
  final Color? lineColor;
  final Color? fillColor;
  final double width;
  final double height;
  final double lineWidth;

  const UILineChart({
    super.key,
    required this.dataPoints,
    this.lineColor,
    this.fillColor,
    this.width = double.infinity,
    this.height = 120.0,
    this.lineWidth = 3.0,
  });

  @override
  State<UILineChart> createState() => _UILineChartState();
}

class _UILineChartState extends State<UILineChart>
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
  void didUpdateWidget(covariant UILineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataPoints != widget.dataPoints) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultLineColor = Theme.of(context).colorScheme.primary;
    final defaultFillColor =
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);

    final resolvedLine = widget.lineColor ?? defaultLineColor;
    final resolvedFill = widget.fillColor ?? defaultFillColor;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: widget.dataPoints.length < 2
          ? const Center(child: Text('Insufficient data to plot chart'))
          : AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: _LineChartPainter(
                    dataPoints: widget.dataPoints,
                    lineColor: resolvedLine,
                    fillColor: resolvedFill,
                    lineWidth: widget.lineWidth,
                    animationValue: _animation.value,
                  ),
                );
              },
            ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;
  final double lineWidth;
  final double animationValue;

  _LineChartPainter({
    required this.dataPoints,
    required this.lineColor,
    required this.fillColor,
    required this.lineWidth,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double maxVal = dataPoints.reduce(max);
    final double minVal = dataPoints.reduce(min);
    final double valRange = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final double widthSegment = size.width / (dataPoints.length - 1);

    final Path path = Path();
    final Path fillPath = Path();

    final double baselineY = size.height;

    // Map first point
    final double firstX = 0;
    final double targetFirstY = size.height -
        ((dataPoints[0] - minVal) / valRange * size.height * 0.8) -
        (size.height * 0.1);
    final double firstY =
        baselineY + (targetFirstY - baselineY) * animationValue;

    path.moveTo(firstX, firstY);
    fillPath.moveTo(firstX, size.height);
    fillPath.lineTo(firstX, firstY);

    for (int i = 1; i < dataPoints.length; i++) {
      final double x = i * widthSegment;
      final double targetY = size.height -
          ((dataPoints[i] - minVal) / valRange * size.height * 0.8) -
          (size.height * 0.1);
      final double y = baselineY + (targetY - baselineY) * animationValue;
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw area fill
    final Paint areaPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor;
    canvas.drawPath(fillPath, areaPaint);

    // Draw line
    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.animationValue != animationValue;
  }
}
