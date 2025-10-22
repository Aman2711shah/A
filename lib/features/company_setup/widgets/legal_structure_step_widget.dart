import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class LegalStructureStepWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const LegalStructureStepWidget({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> legalStructures = [
    {
      'id': 'llc',
      'title': 'Limited Liability Company (LLC)',
      'description': 'Most popular choice for small to medium businesses',
      'icon': Icons.business,
      'recommended': true,
      'minShareholders': 1,
      'maxShareholders': 50,
      'liability': 'Limited',
      'cost': 'Medium',
    },
    {
      'id': 'sole_proprietorship',
      'title': 'Sole Proprietorship',
      'description': 'Simplest structure for individual entrepreneurs',
      'icon': Icons.person,
      'recommended': false,
      'minShareholders': 1,
      'maxShareholders': 1,
      'liability': 'Unlimited',
      'cost': 'Low',
    },
    {
      'id': 'partnership',
      'title': 'Partnership',
      'description': 'For businesses with multiple partners',
      'icon': Icons.handshake,
      'recommended': false,
      'minShareholders': 2,
      'maxShareholders': 20,
      'liability': 'Unlimited',
      'cost': 'Medium',
    },
    {
      'id': 'corporation',
      'title': 'Public Joint Stock Company',
      'description': 'For large businesses planning to go public',
      'icon': Icons.corporate_fare,
      'recommended': false,
      'minShareholders': 3,
      'maxShareholders': null,
      'liability': 'Limited',
      'cost': 'High',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose your legal structure',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the legal structure that best fits your business needs. This affects liability, taxation, and operational requirements.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: ListView.builder(
            itemCount: legalStructures.length,
            itemBuilder: (context, index) {
              final structure = legalStructures[index];
              return _buildStructureCard(structure);
            },
          ),
        ),

        // Information Panel for Selected Structure
        if (formData['legalStructure'] != null)
          _buildInfoPanel(formData['legalStructure']),
      ],
    );
  }

  Widget _buildStructureCard(Map<String, dynamic> structure) {
    final isSelected = formData['legalStructure'] == structure['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 1,
        child: InkWell(
          onTap: () {
            onChanged('legalStructure', structure['id']);
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
                        structure['icon'],
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
                                  structure['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (structure['recommended'])
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Recommended',
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
                            structure['description'],
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

                // Details Row
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailChip(
                        'Liability',
                        structure['liability'],
                        Icons.security,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDetailChip(
                        'Setup Cost',
                        structure['cost'],
                        Icons.attach_money,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDetailChip(
                        'Shareholders',
                        _getShareholderText(structure),
                        Icons.people,
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

  Widget _buildDetailChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
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
    );
  }

  String _getShareholderText(Map<String, dynamic> structure) {
    final min = structure['minShareholders'];
    final max = structure['maxShareholders'];

    if (min == 0 && max == 0) return 'N/A';
    if (min == max) return min.toString();
    if (max == null) return '$min+';
    return '$min-$max';
  }

  Widget _buildInfoPanel(String selectedStructure) {
    final structure = legalStructures.firstWhere(
      (s) => s['id'] == selectedStructure,
    );

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'About ${structure['title']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getStructureInfo(selectedStructure),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getStructureInfo(String structureId) {
    switch (structureId) {
      case 'llc':
        return 'LLCs offer limited liability protection for owners while maintaining operational flexibility. Perfect for most small to medium businesses. Requires minimum capital of AED 300,000 for mainland companies.';
      case 'sole_proprietorship':
        return 'Simplest business structure where you are the sole owner. Easy to set up but offers no liability protection. Your personal assets are at risk for business debts.';
      case 'partnership':
        return 'Business owned by two or more partners who share profits, losses, and management responsibilities. Partners have unlimited liability for business debts.';
      case 'corporation':
        return 'Large-scale business structure suitable for companies planning to issue shares publicly. Requires minimum 3 shareholders and higher capital requirements.';
      default:
        return '';
    }
  }
}
