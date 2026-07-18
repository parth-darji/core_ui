import 'package:flutter/material.dart';

/// Item metadata for UIDesktopSidebar.
class UIDesktopSidebarItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final String? badgeText;
  final List<UIDesktopSidebarItem>? subItems;

  const UIDesktopSidebarItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.badgeText,
    this.subItems,
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

  List<Widget> _buildSidebarItems(BuildContext context, ThemeData theme) {
    final list = <Widget>[];
    int currentIndexCounter = 0;

    for (final item in items) {
      if (item.subItems == null || item.subItems!.isEmpty) {
        final localIndex = currentIndexCounter;
        final isSelected = localIndex == selectedIndex;
        list.add(
          _FlatSidebarItem(
            item: item,
            isSelected: isSelected,
            onTap: () => onItemSelected(localIndex),
          ),
        );
        list.add(const SizedBox(height: 4));
        currentIndexCounter++;
      } else {
        final groupStartIndex = currentIndexCounter;
        final subItemsCount = item.subItems!.length;
        list.add(
          _SidebarGroup(
            item: item,
            selectedIndex: selectedIndex,
            startIndex: groupStartIndex,
            onItemSelected: onItemSelected,
          ),
        );
        list.add(const SizedBox(height: 4));
        currentIndexCounter += subItemsCount;
      }
    }

    return list;
  }

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/app_icon.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.architecture_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      },
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
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: _buildSidebarItems(context, theme),
              ),
            ),
          ),
          if (profileFooter != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: profileFooter!,
            ),
        ],
      ),
    );
  }
}

class _FlatSidebarItem extends StatelessWidget {
  final UIDesktopSidebarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _FlatSidebarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
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
                isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
  }
}

class _SidebarGroup extends StatefulWidget {
  final UIDesktopSidebarItem item;
  final int selectedIndex;
  final int startIndex;
  final ValueChanged<int> onItemSelected;

  const _SidebarGroup({
    required this.item,
    required this.selectedIndex,
    required this.startIndex,
    required this.onItemSelected,
  });

  @override
  State<_SidebarGroup> createState() => _SidebarGroupState();
}

class _SidebarGroupState extends State<_SidebarGroup> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    final subLength = widget.item.subItems?.length ?? 0;
    final endIndex = widget.startIndex + subLength;
    _isExpanded = widget.selectedIndex >= widget.startIndex && widget.selectedIndex < endIndex;
  }

  @override
  void didUpdateWidget(covariant _SidebarGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    final subLength = widget.item.subItems?.length ?? 0;
    final endIndex = widget.startIndex + subLength;
    final hasActiveSub = widget.selectedIndex >= widget.startIndex && widget.selectedIndex < endIndex;
    if (hasActiveSub) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subLength = widget.item.subItems?.length ?? 0;
    final hasActiveSubItem = widget.selectedIndex >= widget.startIndex &&
        widget.selectedIndex < widget.startIndex + subLength;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.item.icon,
                    size: 20,
                    color: hasActiveSubItem
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: hasActiveSubItem ? FontWeight.bold : FontWeight.w500,
                        color: hasActiveSubItem
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded && widget.item.subItems != null) ...[
          const SizedBox(height: 2),
          ...widget.item.subItems!.asMap().entries.map((entry) {
            final subIndex = entry.key;
            final subItem = entry.value;
            final globalIndex = widget.startIndex + subIndex;
            final isSelected = globalIndex == widget.selectedIndex;

            return Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => widget.onItemSelected(globalIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
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
                              ? (subItem.selectedIcon ?? subItem.icon)
                              : subItem.icon,
                          size: 18,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            subItem.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
