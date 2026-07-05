import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Material 3 text input field styled with design system tokens.
class UIInput extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final String? prefixText;
  final String? suffixText;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const UIInput({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBorderColor = isDark ? Colors.white30 : Colors.black12;

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
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            readOnly: readOnly,
            onTap: onTap,
            style: UITypography.bodyLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: UITypography.bodyLarge.copyWith(
                color: Colors.grey.shade400,
              ),
              errorText: errorText,
              errorStyle: UITypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              prefixText: prefixText,
              prefixStyle: UITypography.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              suffixText: suffixText,
              suffixStyle: UITypography.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              prefixIcon: prefix,
              suffixIcon: suffix,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              filled: true,
              fillColor:
                  isDark ? const Color(0xFF222222) : const Color(0xFFF4F6F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: resolvedBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: resolvedBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
