import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

/// Reusable progress milestone Stepper view.
class UIStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color? activeColor;

  const UIStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActive = activeColor ?? Theme.of(context).colorScheme.primary;
    final inactiveColor = isDark ? Colors.white24 : Colors.black12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: List.generate(
          steps.length,
          (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep;

            final circleColor = isCompleted
                ? resolvedActive
                : (isActive
                    ? resolvedActive.withValues(alpha: 0.1)
                    : Colors.transparent);
            final borderColor =
                (isCompleted || isActive) ? resolvedActive : inactiveColor;
            final textColor = (isCompleted || isActive)
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant;

            return Expanded(
              child: Row(
                children: [
                  // Step Node
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor, width: 2.0),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 14.0)
                              : Text(
                                  (index + 1).toString(),
                                  style: UITypography.labelSmall.copyWith(
                                    color:
                                        isActive ? resolvedActive : textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        steps[index],
                        style: UITypography.labelSmall.copyWith(
                          fontSize: 9.0,
                          color: textColor,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // Progress Connector Line
                  if (index < steps.length - 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 14.0, left: 4.0, right: 4.0),
                        child: Container(
                          height: 2.0,
                          color: isCompleted ? resolvedActive : inactiveColor,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
