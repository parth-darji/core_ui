import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enum representing the strength or type of standard haptic impact.
enum UIHapticType {
  none,
  light,
  medium,
  heavy,
  selection,
}

/// A custom premium tap animation wrapper that mimics iOS-style bouncy press feedback and plays tactile haptics.
/// Scales the child widget down when pressed, and returns to normal when released or cancelled.
class UIBounceable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleFactor;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Curve reverseCurve;
  final UIHapticType hapticType;

  const UIBounceable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleFactor = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.reverseDuration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
    this.reverseCurve = Curves.easeOut,
    this.hapticType = UIHapticType.light,
  });

  @override
  State<UIBounceable> createState() => _UIBounceableState();
}

class _UIBounceableState extends State<UIBounceable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  bool get _isInteractive => widget.onTap != null || widget.onLongPress != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UIBounceable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.reverseDuration != widget.reverseDuration) {
      _controller.reverseDuration = widget.reverseDuration;
    }
  }

  void _triggerHaptic() {
    switch (widget.hapticType) {
      case UIHapticType.none:
        break;
      case UIHapticType.light:
        HapticFeedback.lightImpact();
        break;
      case UIHapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case UIHapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case UIHapticType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (!_isInteractive) return;
    _isPressed = true;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!_isPressed) return;
    _isPressed = false;
    _controller.reverse();
    _triggerHaptic();
  }

  void _onTapCancel() {
    if (!_isPressed) return;
    _isPressed = false;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInteractive) {
      return widget.child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress != null
          ? () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            }
          : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
