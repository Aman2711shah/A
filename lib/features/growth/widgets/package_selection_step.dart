import 'package:flutter/material.dart';

class PackageSelectionStep extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const PackageSelectionStep({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final serviceData =
        formData['selectedServiceData'] as Map<String, dynamic>?;

    if (serviceData == null) {
      return const Center(child: Text('No service selected'));
    }

    final premiumPrice = serviceData['Premium Charges (AED)'] ?? 0;
    final standardPrice = serviceData['Standard Charges (AED)'] ?? 0;
    final premiumTimeline = serviceData['Premium Timeline'] ?? 'N/A';
    final standardTimeline = serviceData['Standard Timeline'] ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Package',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select between Premium (faster processing) or Standard package based on your timeline and budget.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),

        // Premium Package
        _buildPackageCard(
          context,
          packageType: 'premium',
          title: 'Premium Package',
          subtitle: 'Fast-track processing',
          price: premiumPrice,
          timeline: premiumTimeline,
          icon: Icons.rocket_launch,
          color: Colors.blue,
          features: [
            'Priority processing',
            'Dedicated account manager',
            'Faster completion',
            '24/7 support',
          ],
        ),

        const SizedBox(height: 16),

        // Standard Package
        _buildPackageCard(
          context,
          packageType: 'standard',
          title: 'Standard Package',
          subtitle: 'Cost-effective solution',
          price: standardPrice,
          timeline: standardTimeline,
          icon: Icons.verified,
          color: Colors.green,
          features: [
            'Standard processing time',
            'Email support',
            'Quality service',
            'Money-back guarantee',
          ],
        ),

        const SizedBox(height: 24),

        // Comparison Table
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Package Comparison',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildComparisonRow(
                'Processing Time',
                premiumTimeline,
                standardTimeline,
              ),
              _buildComparisonRow(
                'Price',
                'AED $premiumPrice',
                'AED $standardPrice',
              ),
              _buildComparisonRow(
                'Support',
                '24/7',
                'Business hours',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard(
    BuildContext context, {
    required String packageType,
    required String title,
    required String subtitle,
    required dynamic price,
    required String timeline,
    required IconData icon,
    required Color color,
    required List<String> features,
  }) {
    final isSelected = formData['selectedPackage'] == packageType;

    return Material(
      color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: () => onChanged('selectedPackage', packageType),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
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
                      color: isSelected ? color : color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : Colors.black87,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: color,
                      size: 28,
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Price and Timeline
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AED ${price.toString()}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Completion: $timeline',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Features
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: color,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String premium, String standard) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              premium,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              standard,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
