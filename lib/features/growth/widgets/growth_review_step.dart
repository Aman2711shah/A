import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class GrowthReviewStep extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const GrowthReviewStep({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final serviceData =
        formData['selectedServiceData'] as Map<String, dynamic>?;
    final selectedPackage = formData['selectedPackage'];

    final price = selectedPackage == 'premium'
        ? (serviceData?['Premium Charges (AED)'] ?? 0)
        : (serviceData?['Standard Charges (AED)'] ?? 0);

    final timeline = selectedPackage == 'premium'
        ? (serviceData?['Premium Timeline'] ?? 'N/A')
        : (serviceData?['Standard Timeline'] ?? 'N/A');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Your Request',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review all the information below before submitting your service request.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Service Details
          _buildSection(
            title: 'Service Details',
            icon: Icons.business_center,
            children: [
              _buildDetailRow('Category', formData['selectedCategory']),
              _buildDetailRow('Service', formData['selectedService']),
              _buildDetailRow(
                'Package',
                selectedPackage == 'premium' ? 'Premium' : 'Standard',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contact Information
          _buildSection(
            title: 'Contact Information',
            icon: Icons.person,
            children: [
              _buildDetailRow('Name', formData['fullName']),
              _buildDetailRow('Email', formData['email']),
              _buildDetailRow('Phone', formData['phone']),
              if (formData['companyName'] != null &&
                  formData['companyName'].toString().isNotEmpty)
                _buildDetailRow('Company', formData['companyName']),
              if (formData['preferredContactMethod'] != null)
                _buildDetailRow(
                    'Contact Method', formData['preferredContactMethod']),
            ],
          ),

          const SizedBox(height: 16),

          // Documents
          _buildSection(
            title: 'Documents',
            icon: Icons.description,
            children: [
              _buildDetailRow(
                'Uploaded',
                '${(formData['uploadedDocuments'] as List<String>?)?.length ?? 0} documents',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Cost Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calculate,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Service Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Total Cost
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Cost',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'AED ${price ?? 0}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),

                // Timeline
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Estimated Timeline',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      timeline ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Terms and Conditions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.gavel,
                      color: Colors.grey[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '• All information provided is accurate and complete\n'
                  '• Service fees are subject to change based on requirements\n'
                  '• Processing times may vary based on document completeness\n'
                  '• Additional fees may apply for urgent processing\n'
                  '• Refund policy applies as per our terms of service\n'
                  '• You agree to our privacy policy and data handling practices',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: formData['agreedToTerms'] ?? false,
                      onChanged: (value) =>
                          onChanged('agreedToTerms', value ?? false),
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onChanged('agreedToTerms',
                            !(formData['agreedToTerms'] ?? false)),
                        child: const Text(
                          'I agree to the terms and conditions and confirm that all information provided is accurate.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Security Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your data is encrypted and securely stored according to UAE data protection laws.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not provided',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
