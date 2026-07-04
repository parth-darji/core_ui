import 'package:flutter/material.dart';
import 'ui_page_indicator.dart';

/// Reusable horizontal sliding layout container.
class UICarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool showIndicator;
  final double viewportFraction;

  const UICarousel({
    super.key,
    required this.items,
    this.height = 180.0,
    this.showIndicator = true,
    this.viewportFraction = 0.85,
  });

  @override
  State<UICarousel> createState() => _UICarouselState();
}

class _UICarouselState extends State<UICarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.08)).clamp(0.9, 1.0);
                  } else {
                    value = index == 0 ? 1.0 : 0.92;
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * widget.height,
                      width: double.infinity,
                      child: child,
                    ),
                  );
                },
                child: widget.items[index],
              );
            },
          ),
        ),
        if (widget.showIndicator && widget.items.isNotEmpty) ...[
          const SizedBox(height: 12.0),
          UIPageIndicator(
            count: widget.items.length,
            activeIndex: _currentPage,
          ),
        ],
      ],
    );
  }
}
