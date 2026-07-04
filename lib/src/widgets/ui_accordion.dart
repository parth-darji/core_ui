import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable Accordion collapsible panel component.
class UIAccordion extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isInitiallyExpanded;
  final Color? headerColor;
  final Color? contentBackgroundColor;

  const UIAccordion({
    super.key,
    required this.title,
    required this.child,
    this.isInitiallyExpanded = false,
    this.headerColor,
    this.contentBackgroundColor,
  });

  @override
  State<UIAccordion> createState() => _UIAccordionState();
}

class _UIAccordionState extends State<UIAccordion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultHeaderColor = Theme.of(context).colorScheme.onSurface;
    final defaultContentBg =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9FAFA);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        InkWell(
          onTap: _handleTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: UITypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.headerColor ?? defaultHeaderColor,
                    ),
                  ),
                ),
                RotationTransition(
                  turns:
                      Tween<double>(begin: 0.0, end: 0.5).animate(_controller),
                  child: Icon(
                    Icons.expand_more,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        AnimatedBuilder(
          animation: _heightFactor,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            color: widget.contentBackgroundColor ?? defaultContentBg,
            padding: const EdgeInsets.all(16.0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
