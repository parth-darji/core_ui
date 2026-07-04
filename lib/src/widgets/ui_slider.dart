import 'package:flutter/material.dart';

/// Reusable custom styled Slider with a premium layout and custom-painted thumb.
class UISlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const UISlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActive = activeColor ?? Theme.of(context).colorScheme.primary;
    final resolvedInactive =
        inactiveColor ?? (isDark ? Colors.white24 : Colors.grey.shade300);

    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: resolvedActive,
        inactiveTrackColor: resolvedInactive,
        thumbColor: Colors.white,
        overlayColor: resolvedActive.withValues(alpha: 0.12),
        trackHeight: 6.0,
        trackShape: const RoundedRectSliderTrackShape(),
        thumbShape: _CustomThumbShape(
          enabledThumbRadius: 10.0,
          borderColor: resolvedActive,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

/// Custom painted slider thumb representing a clean white disc with a colored border and shadow.
class _CustomThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;
  final Color borderColor;

  const _CustomThumbShape({
    required this.enabledThumbRadius,
    required this.borderColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw drop shadow
    final Paint shadowPaint = Paint()
      // ignore: deprecated_member_use
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawCircle(
        center + const Offset(0.0, 1.0), enabledThumbRadius, shadowPaint);

    // Draw white disc center fill
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius, fillPaint);

    // Draw primary accent border ring
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, enabledThumbRadius - 1.5, borderPaint);
  }
}
