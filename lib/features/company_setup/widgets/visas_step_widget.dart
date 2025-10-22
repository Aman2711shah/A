import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class VisasStepWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const VisasStepWidget({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> visaTypes = [
    {
      'id': 'investor_visa',
      'title': 'Investor Visa',
      'description': 'For company owners and major shareholders',
      'icon': Icons.business_center,
      'duration': '2-3 years',
      'cost': 'AED 5,000 - 10,000',
    },
    {
      'id': 'employment_visa',
      'title': 'Employment Visa',
      'description': 'For employees and staff members',
      'icon': Icons.work,
      'duration': '2-3 years',
      'cost': 'AED 3,000 - 5,000',
    },
    {
      'id': 'partner_visa',
      'title': 'Partner Visa',
      'description': 'For business partners with significant stake',
      'icon': Icons.handshake,
      'duration': '2-3 years',
      'cost': 'AED 4,000 - 8,000',
    },
    {
      'id': 'freelance_visa',
      'title': 'Freelance Visa',
      'description': 'For independent professionals and consultants',
      'icon': Icons.person_outline,
      'duration': '1-3 years',
      'cost': 'AED 7,500 - 10,000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final numberOfVisas = formData['numberOfVisas'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visa Requirements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the type of visa needed for your business setup. Different visa types have different requirements and benefits.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),

        // Visa Type Selection
        Expanded(
          child: ListView.builder(
            itemCount: visaTypes.length,
            itemBuilder: (context, index) {
              final visa = visaTypes[index];
              return _buildVisaCard(visa);
            },
          ),
        ),

        const SizedBox(height: 16),

        // Number of Visas Section
        if (formData['visaType'] != null) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Number of Visas Required',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    IconButton(
                      onPressed: numberOfVisas > 0
                          ? () => onChanged('numberOfVisas', numberOfVisas - 1)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      iconSize: 28,
                      color:
                          numberOfVisas > 0 ? AppColors.primary : Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          '$numberOfVisas',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: numberOfVisas < 20
                          ? () => onChanged('numberOfVisas', numberOfVisas + 1)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 28,
                      color:
                          numberOfVisas < 20 ? AppColors.primary : Colors.grey,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Quick selection
                Wrap(
                  spacing: 8,
                  children: [1, 2, 3, 5, 10].map((count) {
                    final isSelected = numberOfVisas == count;
                    return GestureDetector(
                      onTap: () => onChanged('numberOfVisas', count),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary,
                          ),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                if (numberOfVisas > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Estimated cost: ${_calculateVisaCost(formData['visaType'], numberOfVisas)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVisaCard(Map<String, dynamic> visa) {
    final isSelected = formData['visaType'] == visa['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 1,
        child: InkWell(
          onTap: () {
            onChanged('visaType', visa['id']);
            if (formData['numberOfVisas'] == 0) {
              onChanged('numberOfVisas', 1);
            }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        visa['icon'],
                        color: isSelected ? Colors.white : AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            visa['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            visa['description'],
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

                const SizedBox(height: 16),

                // Details Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Duration',
                        visa['duration'],
                        Icons.schedule,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailItem(
                        'Cost',
                        visa['cost'],
                        Icons.attach_money,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateVisaCost(String? visaType, int numberOfVisas) {
    if (visaType == null) return 'AED 0';

    final visaCostMap = {
      'investor_visa': 7500,
      'employment_visa': 4000,
      'partner_visa': 6000,
      'freelance_visa': 8750,
    };

    final costPerVisa = visaCostMap[visaType] ?? 5000;
    final totalCost = costPerVisa * numberOfVisas;

    return 'AED ${totalCost.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }
}
