import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import 'ui_skeleton.dart';
import 'ui_card.dart';
import 'ui_spacing.dart';
import 'ui_divider.dart';

/// Reusable high-level Shimmer components for loading screen skeletons.
class UIShimmer extends StatelessWidget {
  final Widget child;

  const UIShimmer({super.key, required this.child});

  /// A pre-styled list of shimmer cards.
  static Widget list({int itemCount = 3, EdgeInsets padding = const EdgeInsets.all(16)}) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return UICard.elevated(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    UISkeleton(width: 150, height: 18),
                    UISkeleton(width: 60, height: 20),
                  ],
                ),
                const UISpacing.xs(),
                const UISkeleton(width: 250, height: 14),
                const UISpacing.sm(),
                const UIDivider(color: UIColors.separator),
                const UISpacing.xxs(),
                const UISkeleton(width: 100, height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  /// A pre-styled single details or card skeleton.
  static Widget card({EdgeInsets padding = const EdgeInsets.all(16)}) {
    return UICard.elevated(
      margin: padding,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            UISkeleton(width: 200, height: 24),
            UISpacing.md(),
            UISkeleton(width: double.infinity, height: 16),
            UISpacing.sm(),
            UISkeleton(width: double.infinity, height: 16),
            UISpacing.sm(),
            UISkeleton(width: 150, height: 16),
          ],
        ),
      ),
    );
  }

  /// A pre-styled grid of shimmer cards.
  static Widget grid({int itemCount = 4, EdgeInsets padding = const EdgeInsets.all(16)}) {
    return GridView.builder(
      padding: padding,
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        return UICard.elevated(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                UISkeleton(width: 32, height: 32, borderRadius: 16),
                UISpacing.xs(),
                UISkeleton(width: 80, height: 14),
                UISpacing.xxs(),
                UISkeleton(width: 50, height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
