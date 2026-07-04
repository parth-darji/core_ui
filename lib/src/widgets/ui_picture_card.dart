import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';
import 'ui_card.dart';
import 'ui_media_viewer.dart';

/// Reusable Card component featuring a top media banner layout.
class UIPictureCard extends StatelessWidget {
  final String mediaSource;
  final double mediaHeight;
  final String title;
  final String? description;
  final Widget? action;
  final double borderRadius;
  final VoidCallback? onTap;

  const UIPictureCard({
    super.key,
    required this.mediaSource,
    this.mediaHeight = 120.0,
    required this.title,
    this.description,
    this.action,
    this.borderRadius = 16.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return UICard.filled(
      padding: EdgeInsets.zero,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          UIMediaViewer(
            source: mediaSource,
            height: mediaHeight,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: UITypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 6.0),
                  Text(
                    description!,
                    style: UITypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: 12.0),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
