import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import '../tokens/ui_typography.dart';
import 'ui_safe_bottom_spacing.dart';

/// A custom PopupRoute that renders a stationary animated blurred backdrop barrier and slides up the sheet.
class BlurredBottomSheetRoute<T> extends PopupRoute<T> {
  final Widget child;
  final String title;
  final bool showCloseButton;
  final double maxHeightMultiplier;

  BlurredBottomSheetRoute({
    required this.child,
    required this.title,
    required this.showCloseButton,
    required this.maxHeightMultiplier,
    super.settings,
  });

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'BlurredBottomSheet';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return UIBottomSheet(
      title: title,
      showCloseButton: showCloseButton,
      maxHeightMultiplier: maxHeightMultiplier,
      child: child,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
    );

    return Stack(
      children: [
        // Smoothly animated backdrop blur and dim overlay (completely stationary)
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final curvedValue =
                    Curves.easeOutQuart.transform(animation.value);
                final sigma = curvedValue * 8.0;
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                  child: Container(
                    color: Colors.black.withValues(alpha: curvedValue * 0.35),
                  ),
                );
              },
            ),
          ),
        ),
        // Bottom sheet card slides up and fades in
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: FadeTransition(
              opacity: curvedAnimation,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

/// Reusable Material 3 Bottom Sheet template with standard dragging handle.
class UIBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showCloseButton;
  final double maxHeightMultiplier;

  const UIBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.showCloseButton = true,
    this.maxHeightMultiplier = 0.85,
  });

  /// Helper to trigger the bottom sheet natively in context
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    bool showCloseButton = true,
    double maxHeightMultiplier = 0.85,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return Navigator.push<T>(
      context,
      BlurredBottomSheetRoute<T>(
        title: title,
        showCloseButton: showCloseButton,
        maxHeightMultiplier: maxHeightMultiplier,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg =
        isDark ? const Color(0xFF1A1A1A) : UIColors.cardBackground;

    // Register dependency on MediaQuery to rebuild when keyboard state changes
    final mediaQuery = MediaQuery.of(context);

    final view = View.of(context);
    final pixelRatio = view.devicePixelRatio;
    final screenHeight = view.physicalSize.height / pixelRatio;
    final keyboardHeight = view.viewInsets.bottom / pixelRatio;
    final statusBarHeight = view.padding.top / pixelRatio;

    // Dynamically constrain sheet height to the visible viewport above the keyboard using raw unconsumed view insets
    final maxSheetHeight = (screenHeight - keyboardHeight - statusBarHeight - 16.0) * maxHeightMultiplier;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: resolvedBg,
          type: MaterialType.canvas,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxSheetHeight,
            ),
            child: SafeArea(
              top: true,
              bottom:
                  false, // Handled manually by UISafeBottomSpacing to prevent overlap with gesture line or 3-button nav
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8.0),
                  // Material 3 Drag Handle
                  Center(
                    child: Container(
                      width: 32.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white30 : Colors.black12,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: UITypography.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (showCloseButton)
                          IconButton(
                            icon: const Icon(Icons.close, size: 20.0),
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            onPressed: () => Navigator.pop(context),
                          ),
                      ],
                    ),
                  ),
                  const Divider(color: UIColors.separator, height: 1.0),
                  // Main content scrollable if it exceeds bounds
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                      child: child,
                    ),
                  ),
                  // Safe bottom spacing for gesture line / Android 3-button navigation
                  const UISafeBottomSpacing(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
