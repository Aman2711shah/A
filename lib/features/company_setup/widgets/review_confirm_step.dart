import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wazeet_app/features/company_setup/providers/company_setup_provider.dart';
import '../../../config/theme/app_colors.dart';

class ReviewConfirmStep extends StatelessWidget {
  const ReviewConfirmStep({super.key});

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
                'Review & Confirm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please review all the information below before submitting your company setup application.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    // Business Activity Section
                    _buildReviewSection(
                      'Business Activity',
                      _getActivityTitle(provider.selectedActivity),
                      Icons.business,
                      () => provider.goToStep(0),
                    ),

                    // Legal Structure Section
                    _buildReviewSection(
                      'Legal Structure',
                      _getLegalStructureTitle(provider.selectedLegalStructure),
                      Icons.account_balance,
                      () => provider.goToStep(1),
                    ),

                    // Shareholders Section
                    _buildReviewSection(
                      'Shareholders',
                      '${provider.numberOfShareholders} shareholder${provider.numberOfShareholders > 1 ? 's' : ''}',
                      Icons.people,
                      () => provider.goToStep(2),
                    ),

                    // Visa Requirements Section
                    _buildReviewSection(
                      'Visa Requirements',
                      '${_getVisaTypeTitle(provider.visaType)} (${provider.numberOfVisas} visa${provider.numberOfVisas != 1 ? 's' : ''})',
                      Icons.card_membership,
                      () => provider.goToStep(3),
                    ),

                    // Office Space Section
                    _buildReviewSection(
                      'Office Space',
                      '${_getOfficeSpaceTitle(provider.officeSpaceType)}${provider.hasEjari ? ' (with Ejari)' : ''}',
                      Icons.location_city,
                      () => provider.goToStep(4),
                    ),

                    // Documents Section
                    _buildReviewSection(
                      'Documents',
                      '${provider.uploadedDocuments.length} document${provider.uploadedDocuments.length != 1 ? 's' : ''} uploaded',
                      Icons.description,
                      () => provider.goToStep(5),
                    ),

                    const SizedBox(height: 24),

                    // Cost Estimate
                    _buildCostEstimate(provider),

                    const SizedBox(height: 24),

                    // Timeline Estimate
                    _buildTimelineEstimate(),

                    const SizedBox(height: 24),

                    // Terms and Conditions
                    _buildTermsAndConditions(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewSection(
    String title,
    String? value,
    IconData icon,
    VoidCallback onEdit,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? 'Not selected',
                  style: TextStyle(
                    fontSize: 16,
                    color: value != null ? Colors.black87 : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCostEstimate(CompanySetupProvider provider) {
    final costs = _calculateCosts(provider);
    final total = costs.values.fold<double>(0, (sum, cost) => sum + cost);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Estimated Costs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...costs.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'AED ${entry.value.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Estimated Cost',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'AED ${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[700],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This is an estimate. Final costs may vary based on government fees and additional requirements.',
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

  Widget _buildTimelineEstimate() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Colors.green[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Expected Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimelineItem('Document Review', '1-2 business days'),
          _buildTimelineItem('License Application', '3-5 business days'),
          _buildTimelineItem('Visa Processing', '5-10 business days'),
          _buildTimelineItem('Emirates ID', '2-3 business days'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Total estimated time: 12-20 business days',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
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

  Widget _buildTimelineItem(String title, String duration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
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
            '• Government fees are subject to change\n'
            '• Processing times may vary based on government processing\n'
            '• Additional documents may be requested during processing\n'
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
              Icon(
                Icons.security,
                color: Colors.blue[600],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your data is encrypted and securely stored according to UAE data protection laws.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, double> _calculateCosts(CompanySetupProvider provider) {
    final costs = <String, double>{};

    // Base license cost
    if (provider.selectedLegalStructure == 'llc') {
      costs['Business License'] = 15000.0;
    } else if (provider.selectedLegalStructure == 'sole_proprietorship') {
      costs['Business License'] = 8000.0;
    } else {
      costs['Business License'] = 12000.0;
    }

    // Visa costs
    if (provider.visaType != null && provider.numberOfVisas > 0) {
      final visaCosts = {
        'investor_visa': 7500.0,
        'employment_visa': 4000.0,
        'partner_visa': 6000.0,
        'freelance_visa': 8750.0,
      };
      final costPerVisa = visaCosts[provider.visaType] ?? 5000.0;
      costs['Visa Processing'] =
          costPerVisa * provider.numberOfVisas.toDouble();
    }

    // Office space costs (annual)
    if (provider.officeSpaceType != null) {
      final officeCosts = {
        'physical_office': 25000.0,
        'virtual_office': 5000.0,
        'shared_office': 12000.0,
        'home_office': 2000.0,
      };
      costs['Office Space (Annual)'] =
          officeCosts[provider.officeSpaceType] ?? 15000.0;
    }

    // Ejari costs
    if (!provider.hasEjari &&
        (provider.officeSpaceType == 'physical_office' ||
            provider.officeSpaceType == 'shared_office')) {
      costs['Ejari Registration'] = 2000.0;
    }

    // WAZEET service fee
    costs['WAZEET Service Fee'] = 5000.0;

    return costs;
  }

  String? _getActivityTitle(String? activityId) {
    if (activityId == null) return null;

    const activityTitles = {
      'trading': 'Trading & Import/Export',
      'consulting': 'Business Consulting',
      'technology': 'Technology Services',
      'retail': 'Retail & E-commerce',
      'real_estate': 'Real Estate',
      'healthcare': 'Healthcare Services',
      'education': 'Education & Training',
      'hospitality': 'Hospitality & Tourism',
      'manufacturing': 'Manufacturing',
      'finance': 'Financial Services',
      'other': 'Other',
    };

    return activityTitles[activityId];
  }

  String? _getLegalStructureTitle(String? structureId) {
    if (structureId == null) return null;

    const structureTitles = {
      'llc': 'Limited Liability Company (LLC)',
      'sole_proprietorship': 'Sole Proprietorship',
      'partnership': 'Partnership',
      'corporation': 'Public Joint Stock Company',
      'branch': 'Branch Office',
      'representative_office': 'Representative Office',
    };

    return structureTitles[structureId];
  }

  String? _getVisaTypeTitle(String? visaId) {
    if (visaId == null) return null;

    const visaTitles = {
      'investor_visa': 'Investor Visa',
      'employment_visa': 'Employment Visa',
      'partner_visa': 'Partner Visa',
      'freelance_visa': 'Freelance Visa',
    };

    return visaTitles[visaId];
  }

  String? _getOfficeSpaceTitle(String? officeId) {
    if (officeId == null) return null;

    const officeTitles = {
      'physical_office': 'Physical Office',
      'virtual_office': 'Virtual Office',
      'shared_office': 'Shared/Co-working Space',
      'home_office': 'Home Office',
    };

    return officeTitles[officeId];
  }
}
