import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Search Bar styled with design system tokens.
class UISearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? trailing;

  const UISearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFEFEFEF);
    final resolvedBorderColor = isDark ? Colors.white10 : Colors.black12;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: resolvedBg,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: resolvedBorderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey, size: 20.0),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: UITypography.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: UITypography.bodyLarge.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            if (controller != null && controller!.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: 18.0),
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  controller!.clear();
                  onClear?.call();
                  onChanged?.call('');
                },
              ),
            if (trailing != null) ...[
              const SizedBox(width: 8.0),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
