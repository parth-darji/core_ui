import 'package:flutter/widgets.dart';

/// Unified semantic spacing helper widgets to maintain consistent grid alignment.
class UISpacing extends StatelessWidget {
  final double width;
  final double height;

  /// Extra Extra Small spacing gap (4.0).
  const UISpacing.xxs({super.key})
      : width = 4.0,
        height = 4.0;

  /// Extra Small spacing gap (8.0).
  const UISpacing.xs({super.key})
      : width = 8.0,
        height = 8.0;

  /// Small spacing gap (12.0).
  const UISpacing.sm({super.key})
      : width = 12.0,
        height = 12.0;

  /// Medium spacing gap (16.0).
  const UISpacing.md({super.key})
      : width = 16.0,
        height = 16.0;

  /// Large spacing gap (24.0).
  const UISpacing.lg({super.key})
      : width = 24.0,
        height = 24.0;

  /// Extra Large spacing gap (32.0).
  const UISpacing.xl({super.key})
      : width = 32.0,
        height = 32.0;

  /// Extra Extra Large spacing gap (48.0).
  const UISpacing.xxl({super.key})
      : width = 48.0,
        height = 48.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
