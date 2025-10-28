import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class ContactInformationStep extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const ContactInformationStep({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your contact details so our team can reach you to discuss your service request.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Full Name
          TextFormField(
            initialValue: formData['fullName'],
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => onChanged('fullName', value),
          ),

          const SizedBox(height: 16),

          // Email
          TextFormField(
            initialValue: formData['email'],
            decoration: const InputDecoration(
              labelText: 'Email Address *',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => onChanged('email', value),
          ),

          const SizedBox(height: 16),

          // Phone
          TextFormField(
            initialValue: formData['phone'],
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              hintText: '+971 XX XXX XXXX',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (value) => onChanged('phone', value),
          ),

          const SizedBox(height: 16),

          // Company Name (Optional)
          TextFormField(
            initialValue: formData['companyName'],
            decoration: const InputDecoration(
              labelText: 'Company Name (Optional)',
              hintText: 'Your company name',
              prefixIcon: Icon(Icons.business_outlined),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => onChanged('companyName', value),
          ),

          const SizedBox(height: 24),

          // Preferred Contact Method
          const Text(
            'Preferred Contact Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildContactMethodChip('Email', Icons.email_outlined),
              _buildContactMethodChip('Phone', Icons.phone_outlined),
              _buildContactMethodChip('WhatsApp', Icons.chat_outlined),
            ],
          ),

          const SizedBox(height: 24),

          // Message (Optional)
          TextFormField(
            initialValue: formData['message'],
            decoration: const InputDecoration(
              labelText: 'Message (Optional)',
              hintText:
                  'Tell us about your business needs or any specific questions...',
              prefixIcon: Icon(Icons.message_outlined),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            onChanged: (value) => onChanged('message', value),
          ),

          const SizedBox(height: 24),

          // Service Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
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
                    const Text(
                      'Service Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  'Category',
                  formData['selectedCategory'] ?? 'Not selected',
                ),
                _buildSummaryRow(
                  'Service',
                  formData['selectedService'] ?? 'Not selected',
                ),
                _buildSummaryRow(
                  'Package',
                  formData['selectedPackage'] == 'premium'
                      ? 'Premium'
                      : 'Standard',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethodChip(String method, IconData icon) {
    final isSelected = formData['preferredContactMethod'] == method;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppColors.white : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(method),
        ],
      ),
      onSelected: (selected) {
        if (selected) {
          onChanged('preferredContactMethod', method);
        }
      },
      selectedColor: AppColors.primary,
      checkmarkColor: AppColors.white,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
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
