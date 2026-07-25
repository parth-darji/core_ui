import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import '../tokens/ui_typography.dart';
import 'ui_bounceable.dart';

/// Reusable premium Option Selector menu button that displays choices inside a center modal dialog.
class UIDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String labelText;
  final String? hintText;
  final String? errorText;
  final String? emptyText;

  const UIDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.emptyText,
  });

  void _showOptionsDialog(BuildContext context) {
    showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: labelText,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final resolvedBg =
            isDark ? const Color(0xFF1E1E1E) : UIColors.cardBackground;

        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 450.0),
            decoration: BoxDecoration(
              color: resolvedBg,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        labelText,
                        style: UITypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(height: 1.0, color: UIColors.separator),
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 28.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          emptyText ?? 'No options available',
                          style: UITypography.bodyMedium.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: items.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1.0,
                            color: UIColors.separator,
                          ),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isSelected = item.value == value;

                            return UIBounceable(
                              onTap: () {
                                Navigator.pop(context);
                                onChanged(item.value);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 14.0,
                                ),
                                color: isSelected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1)
                                    : Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DefaultTextStyle(
                                        style: UITypography.bodyMedium.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        child: item.child,
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20.0,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: ScaleTransition(
              scale:
                  Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null && errorText!.isNotEmpty;
    final resolvedBorderColor = hasError
        ? Theme.of(context).colorScheme.error
        : (isDark ? Colors.white30 : Colors.black12);

    final selectedItem = items.cast<DropdownMenuItem<T>?>().firstWhere(
          (item) => item?.value == value,
          orElse: () => null,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: UITypography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6.0),
          UIBounceable(
            onTap: () => _showOptionsDialog(context),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF222222) : const Color(0xFFF4F6F6),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: resolvedBorderColor,
                  width: hasError ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: selectedItem != null
                        ? DefaultTextStyle(
                            style: UITypography.bodyLarge.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            child: selectedItem.child,
                          )
                        : Text(
                            hintText ?? '',
                            style: UITypography.bodyLarge.copyWith(
                              color: Colors.grey.shade400,
                            ),
                          ),
                  ),
                  Icon(
                    Icons.unfold_more,
                    color: hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                errorText!,
                style: UITypography.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
