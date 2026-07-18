import 'package:flutter/material.dart';

/// Helper class to query responsiveness breakpoints.
class UIResponsive {
  static const double mobileMax = 799.0;
  static const double tabletMax = 1199.0;

  static bool isMobile(BuildContext context, {double breakpoint = 800.0}) {
    return MediaQuery.of(context).size.width < breakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 800.0 && width <= tabletMax;
  }

  static bool isDesktop(BuildContext context, {double breakpoint = 800.0}) {
    return MediaQuery.of(context).size.width >= breakpoint;
  }

  static int gridColumns(BuildContext context, {double targetWidth = 360.0}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 800.0) return 1;
    final contentWidth = width - 260.0;
    final cols = (contentWidth / targetWidth).floor();
    return cols < 1 ? 1 : (cols > 4 ? 4 : cols);
  }
}

/// A layout widget that switches between mobile, tablet (optional), and desktop layouts.
class UIResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final double desktopBreakpoint;

  const UIResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.desktopBreakpoint = 800.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopBreakpoint) {
          return desktop;
        }
        if (tablet != null && constraints.maxWidth >= 600.0) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}

/// Item metadata for UIDesktopSidebar.
class UIDesktopSidebarItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final String? badgeText;

  const UIDesktopSidebarItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.badgeText,
  });
}

/// A desktop sidebar navigation rail component.
class UIDesktopSidebar extends StatelessWidget {
  final String appName;
  final Widget? logo;
  final List<UIDesktopSidebarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Widget? profileFooter;

  const UIDesktopSidebar({
    super.key,
    required this.appName,
    this.logo,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.profileFooter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? theme.colorScheme.surface
        : const Color(0xFFF7F9FC);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                if (logo != null)
                  logo!
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.architecture_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                const SizedBox(width: 12),
                Text(
                  appName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onItemSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? (item.selectedIcon ?? item.icon)
                                : item.icon,
                            size: 20,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (item.badgeText != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.badgeText!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (profileFooter != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: profileFooter!,
            ),
          ],
        ],
      ),
    );
  }
}
