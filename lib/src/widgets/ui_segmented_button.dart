import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Segmented Button matching Material 3 specification rules.
class UISegmentedButton<T extends Object> extends StatelessWidget {
  final Set<T> selected;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<Set<T>> onSelectionChanged;
  final bool emptySelectionAllowed;
  final bool multiSelectionEnabled;

  const UISegmentedButton({
    super.key,
    required this.selected,
    required this.segments,
    required this.onSelectionChanged,
    this.emptySelectionAllowed = false,
    this.multiSelectionEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      emptySelectionAllowed: emptySelectionAllowed,
      multiSelectionEnabled: multiSelectionEnabled,
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Theme.of(context).colorScheme.primary,
        selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
        textStyle: UITypography.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
