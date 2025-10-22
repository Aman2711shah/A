import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        
        return Expanded(
          child: Row(
            children: [
              // Step Circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Theme.of(context).primaryColor
                      : isActive
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              
              // Step Label
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    steps[index],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isActive || isCompleted
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              
              // Connector Line
              if (index < steps.length - 1)
                Container(
                  height: 2,
                  width: 20,
                  color: isCompleted
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
            ],
          ),
        );
      }),
    );
  }
}
