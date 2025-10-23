import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wazeet_app/features/company_setup/providers/company_setup_provider.dart';
import '../../../config/theme/app_colors.dart';

class OfficeSpaceStep extends StatelessWidget {
  const OfficeSpaceStep({super.key});

  static const List<Map<String, dynamic>> officeTypes = [
    {
      'id': 'physical_office',
      'title': 'Physical Office',
      'description': 'Traditional office space with full facilities',
      'icon': Icons.business,
      'recommended': true,
      'cost': 'AED 15,000 - 50,000/year',
      'advantages': [
        'Professional business address',
        'Meeting rooms and facilities',
        'Client meeting space',
        'Storage facilities',
        'Mail handling services',
      ],
      'requirements': [
        'Tenancy contract (Ejari)',
        'NOC from landlord',
        'Utility connections',
        'Office furnishing',
      ],
    },
    {
      'id': 'virtual_office',
      'title': 'Virtual Office',
      'description': 'Business address without physical presence',
      'icon': Icons.cloud,
      'recommended': false,
      'cost': 'AED 3,000 - 8,000/year',
      'advantages': [
        'Cost-effective solution',
        'Professional address',
        'Mail forwarding',
        'Call answering service',
        'Meeting room access (hourly)',
      ],
      'requirements': [
        'Virtual office agreement',
        'Service provider NOC',
        'Address verification',
        'Limited business activities',
      ],
    },
    {
      'id': 'shared_office',
      'title': 'Shared/Co-working Space',
      'description': 'Flexible workspace with shared amenities',
      'icon': Icons.people_alt,
      'recommended': false,
      'cost': 'AED 8,000 - 20,000/year',
      'advantages': [
        'Flexible terms',
        'Networking opportunities',
        'Shared facilities',
        'Professional environment',
        'Scalable workspace',
      ],
      'requirements': [
        'Co-working agreement',
        'Facility management NOC',
        'Desk allocation proof',
        'Shared resource access',
      ],
    },
    {
      'id': 'home_office',
      'title': 'Home Office',
      'description': 'Work from residential premises (limited activities)',
      'icon': Icons.home,
      'recommended': false,
      'cost': 'AED 1,000 - 5,000/year',
      'advantages': [
        'Lowest cost option',
        'No commute required',
        'Flexible working hours',
        'Family proximity',
        'Personal comfort',
      ],
      'requirements': [
        'Residential permit',
        'Landlord approval',
        'Activity restrictions',
        'Limited client meetings',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanySetupProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
                    return _buildOfficeCard(context, provider, office);
                  },
                ),
              ),

              // Ejari Information Section
              if (provider.officeSpaceType != null &&
                  (provider.officeSpaceType == 'physical_office' ||
                      provider.officeSpaceType == 'shared_office')) ...[
                const SizedBox(height: 16),
                _buildEjariSection(provider),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfficeCard(
    BuildContext context,
    CompanySetupProvider provider,
    Map<String, dynamic> office,
  ) {
    final isSelected = provider.officeSpaceType == office['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 1,
        child: InkWell(
          onTap: () {
            provider.setOfficeSpaceType(office['id']);
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

                if (isSelected) ...[
                  const SizedBox(height: 16),

                  // Advantages
                  _buildListSection(
                    'Advantages',
                    office['advantages'],
                    Icons.check_circle_outline,
                    Colors.green,
                  ),

                  const SizedBox(height: 12),

                  // Requirements
                  _buildListSection(
                    'Requirements',
                    office['requirements'],
                    Icons.assignment,
                    Colors.orange,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListSection(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 22, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildEjariSection(CompanySetupProvider provider) {
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
                  onTap: () => provider.setHasEjari(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          provider.hasEjari ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: provider.hasEjari
                            ? AppColors.primary
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: provider.hasEjari
                              ? Colors.white
                              : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Yes, I have Ejari',
                          style: TextStyle(
                            color: provider.hasEjari
                                ? Colors.white
                                : Colors.grey[600],
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
                  onTap: () => provider.setHasEjari(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !provider.hasEjari ? Colors.orange : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !provider.hasEjari
                            ? Colors.orange
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: !provider.hasEjari
                              ? Colors.white
                              : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Need help with Ejari',
                          style: TextStyle(
                            color: !provider.hasEjari
                                ? Colors.white
                                : Colors.grey[600],
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
          if (!provider.hasEjari) ...[
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
