import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/ui_colors.dart';
import '../tokens/ui_typography.dart';
import 'ui_safe_bottom_spacing.dart';
import 'ui_divider.dart';

/// A custom PopupRoute that renders a stationary animated blurred backdrop barrier and slides up the sheet.
class BlurredBottomSheetRoute<T> extends PopupRoute<T> {
  final Widget child;
  final String title;
  final Widget? titleWidget;
  final bool showCloseButton;
  final double maxHeightMultiplier;
  final bool showDivider;
  final Widget? actionButton;

  BlurredBottomSheetRoute({
    required this.child,
    required this.title,
    this.titleWidget,
    required this.showCloseButton,
    required this.maxHeightMultiplier,
    required this.showDivider,
    this.actionButton,
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
      titleWidget: titleWidget,
      showCloseButton: showCloseButton,
      maxHeightMultiplier: maxHeightMultiplier,
      showDivider: showDivider,
      actionButton: actionButton,
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
  final Widget? titleWidget;
  final Widget child;
  final bool showCloseButton;
  final double maxHeightMultiplier;
  final bool showDivider;
  final Widget? actionButton;

  const UIBottomSheet({
    super.key,
    required this.title,
    this.titleWidget,
    required this.child,
    this.showCloseButton = true,
    this.maxHeightMultiplier = 0.85,
    this.showDivider = true,
    this.actionButton,
  });

  /// Helper to trigger the bottom sheet natively in context
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    Widget? titleWidget,
    Widget? actionButton,
    bool showCloseButton = true,
    double maxHeightMultiplier = 0.85,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDivider = true,
  }) {
    return Navigator.push<T>(
      context,
      BlurredBottomSheetRoute<T>(
        title: title,
        titleWidget: titleWidget,
        showCloseButton: showCloseButton,
        maxHeightMultiplier: maxHeightMultiplier,
        showDivider: showDivider,
        actionButton: actionButton,
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
    MediaQuery.of(context);

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
      body: SafeArea(
        top: true,
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.pop(context),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // Intercept tap events inside the bottom sheet card
              child: Material(
                color: resolvedBg,
                type: MaterialType.canvas,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: maxSheetHeight,
                    maxWidth: 640.0,
                  ),
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8.0),
                        // Material 3 Drag Handle (Sticky)
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
                        // Sticky Header title row
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: titleWidget ?? Text(
                                  title,
                                  style: UITypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (showCloseButton)
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 18.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (showDivider) const UIDivider(height: 1.0),
                        // Scrollable Content & Overlay Action Button inside a Flexible stack
                        Flexible(
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 16.0,
                                  bottom: actionButton != null ? 140.0 : 24.0,
                                ),
                                child: child,
                              ),
                              if (actionButton != null)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          resolvedBg,
                                          resolvedBg,
                                          resolvedBg.withValues(alpha: 0.9),
                                          resolvedBg.withValues(alpha: 0.0),
                                        ],
                                        stops: const [0.0, 0.4, 0.7, 1.0],
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 32.0,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: UISafeBottomSpacing.getPadding(context, fallbackMargin: 20.0),
                                      ),
                                      child: actionButton!,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (actionButton == null) const UISafeBottomSpacing(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
