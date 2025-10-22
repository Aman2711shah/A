import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class OfficeStepWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const OfficeStepWidget({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> officeTypes = [
    {
      'id': 'physical_office',
      'title': 'Physical Office',
      'description': 'Traditional office space with full facilities',
      'icon': Icons.business,
      'recommended': true,
      'cost': 'AED 15,000 - 50,000/year',
    },
    {
      'id': 'virtual_office',
      'title': 'Virtual Office',
      'description': 'Business address without physical presence',
      'icon': Icons.cloud,
      'recommended': false,
      'cost': 'AED 3,000 - 8,000/year',
    },
    {
      'id': 'shared_office',
      'title': 'Shared/Co-working Space',
      'description': 'Flexible workspace with shared amenities',
      'icon': Icons.people_alt,
      'recommended': false,
      'cost': 'AED 8,000 - 20,000/year',
    },
    {
      'id': 'home_office',
      'title': 'Home Office',
      'description': 'Work from residential premises (limited activities)',
      'icon': Icons.home,
      'recommended': false,
      'cost': 'AED 1,000 - 5,000/year',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Office Space Requirements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the type of office space that suits your business needs and budget. This affects your business license requirements.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: ListView.builder(
            itemCount: officeTypes.length,
            itemBuilder: (context, index) {
              final office = officeTypes[index];
              return _buildOfficeCard(office);
            },
          ),
        ),

        // Ejari Information Section
        if (formData['officeType'] != null &&
            (formData['officeType'] == 'physical_office' ||
                formData['officeType'] == 'shared_office')) ...[
          const SizedBox(height: 16),
          _buildEjariSection(),
        ],
      ],
    );
  }

  Widget _buildOfficeCard(Map<String, dynamic> office) {
    final isSelected = formData['officeType'] == office['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 1,
        child: InkWell(
          onTap: () {
            onChanged('officeType', office['id']);
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
                        office['icon'],
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
                                  office['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (office['recommended'])
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
                            office['description'],
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

                // Cost Information
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        office['cost'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEjariSection() {
    final hasEjari = formData['hasEjari'] ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.home_work,
                color: Colors.blue[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Ejari Registration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ejari is mandatory for physical office spaces in Dubai. It\'s a tenancy contract registration with RERA.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Do you already have an Ejari-registered office?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged('hasEjari', true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: hasEjari ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hasEjari ? AppColors.primary : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: hasEjari ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Yes, I have Ejari',
                          style: TextStyle(
                            color: hasEjari ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged('hasEjari', false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !hasEjari ? Colors.orange : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !hasEjari ? Colors.orange : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: !hasEjari ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Need help with Ejari',
                          style: TextStyle(
                            color: !hasEjari ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!hasEjari) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Our team will help you with Ejari registration. Additional cost: AED 1,500 - 3,000',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
