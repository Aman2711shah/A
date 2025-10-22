import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<int> completedSteps;

  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.completedSteps = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Step Circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              totalSteps,
              (index) => _buildStepCircle(index + 1),
            ),
          ),

          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: currentStep / totalSteps,
              backgroundColor: AppColors.lightGrey,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 8),

          // Step Text
          Text(
            'Step $currentStep of $totalSteps',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step) {
    final isCompleted = completedSteps.contains(step);
    final isCurrent = step == currentStep;

    Color backgroundColor;
    Color textColor;
    Widget child;

    if (isCompleted) {
      backgroundColor = AppColors.primary;
      textColor = AppColors.white;
      child = const Icon(Icons.check, color: AppColors.white, size: 20);
    } else if (isCurrent) {
      backgroundColor = AppColors.primary;
      textColor = AppColors.white;
      child = Text(
        '$step',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    } else {
      backgroundColor = AppColors.lightGrey;
      textColor = AppColors.textSecondary;
      child = Text(
        '$step',
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }
}
