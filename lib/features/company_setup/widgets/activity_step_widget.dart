import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class ActivityStepWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const ActivityStepWidget({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> businessActivities = [
    {
      'id': 'trading',
      'title': 'Trading & Import/Export',
      'description': 'Buy and sell goods locally or internationally',
      'icon': Icons.swap_horiz,
      'popular': true,
    },
    {
      'id': 'consulting',
      'title': 'Business Consulting',
      'description': 'Provide professional advisory services',
      'icon': Icons.business_center,
      'popular': true,
    },
    {
      'id': 'technology',
      'title': 'Technology Services',
      'description': 'Software development, IT solutions',
      'icon': Icons.computer,
      'popular': true,
    },
    {
      'id': 'retail',
      'title': 'Retail & E-commerce',
      'description': 'Online and offline retail operations',
      'icon': Icons.store,
      'popular': false,
    },
    {
      'id': 'real_estate',
      'title': 'Real Estate',
      'description': 'Property development and management',
      'icon': Icons.home_work,
      'popular': false,
    },
    {
      'id': 'healthcare',
      'title': 'Healthcare Services',
      'description': 'Medical and wellness services',
      'icon': Icons.local_hospital,
      'popular': false,
    },
    {
      'id': 'education',
      'title': 'Education & Training',
      'description': 'Educational institutions and training centers',
      'icon': Icons.school,
      'popular': false,
    },
    {
      'id': 'hospitality',
      'title': 'Hospitality & Tourism',
      'description': 'Hotels, restaurants, travel services',
      'icon': Icons.hotel,
      'popular': false,
    },
    {
      'id': 'manufacturing',
      'title': 'Manufacturing',
      'description': 'Production and industrial activities',
      'icon': Icons.precision_manufacturing,
      'popular': false,
    },
    {
      'id': 'finance',
      'title': 'Financial Services',
      'description': 'Banking, investment, insurance services',
      'icon': Icons.account_balance,
      'popular': false,
    },
    {
      'id': 'other',
      'title': 'Other',
      'description': 'Specify your business activity',
      'icon': Icons.more_horiz,
      'popular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your primary business activity?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the main activity your company will engage in. This helps us determine the appropriate license requirements.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),

        // Popular Activities Section
        const Text(
          'Popular Activities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        ...businessActivities
            .where((activity) => activity['popular'] == true)
            .map((activity) => _buildActivityCard(activity)),

        const SizedBox(height: 24),

        // All Activities Section
        const Text(
          'All Activities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: ListView(
            children: businessActivities
                .where((activity) => activity['popular'] == false)
                .map((activity) => _buildActivityCard(activity))
                .toList(),
          ),
        ),

        // Custom Activity Input
        if (formData['selectedActivity'] == 'other')
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify your business activity',
                hintText: 'Enter details about your business',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              initialValue: formData['customActivity'] ?? '',
              onChanged: (value) {
                onChanged('customActivity', value);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final isSelected = formData['selectedActivity'] == activity['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 1,
        child: InkWell(
          onTap: () {
            onChanged('selectedActivity', activity['id']);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    activity['icon'],
                    color: isSelected ? Colors.white : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              activity['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (activity['popular'])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Popular',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
