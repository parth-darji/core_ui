import 'package:flutter/material.dart';

/// Reusable circular progress loading indicator.
class UILoading extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const UILoading({
    super.key,
    this.size = 28.0,
    this.strokeWidth = 3.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(resolvedColor),
      ),
    );
  }
}
