import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_setup_provider.dart';
import '../../../config/theme/app_colors.dart';

class ShareholdersStep extends StatelessWidget {
  const ShareholdersStep({super.key});

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
                'Shareholders Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Specify the number of shareholders for your company. This affects the required documentation and approval process.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Number of Shareholders Selector
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Number of Shareholders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: provider.numberOfShareholders > 1
                              ? () => provider.setNumberOfShareholders(
                                    provider.numberOfShareholders - 1,
                                  )
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 32,
                          color: provider.numberOfShareholders > 1
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${provider.numberOfShareholders}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: provider.numberOfShareholders < 50
                              ? () => provider.setNumberOfShareholders(
                                    provider.numberOfShareholders + 1,
                                  )
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 32,
                          color: provider.numberOfShareholders < 50
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Maximum 50 shareholders for LLC',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Selection Buttons
              const Text(
                'Quick Selection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [1, 2, 3, 4, 5, 10].map((count) {
                  final isSelected = provider.numberOfShareholders == count;
                  return GestureDetector(
                    onTap: () => provider.setNumberOfShareholders(count),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        count == 1 ? 'Solo Founder' : '$count Shareholders',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Information Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildInfoCard(
                      'Single Shareholder',
                      'Simplest structure with one owner holding 100% shares. Faster approval process and minimal documentation.',
                      Icons.person,
                      provider.numberOfShareholders == 1,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Multiple Shareholders',
                      'Shared ownership with multiple partners. Requires shareholder agreement and detailed ownership structure.',
                      Icons.people,
                      provider.numberOfShareholders > 1,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Required Documents',
                      'Each shareholder needs passport copies, photos, NOC (if applicable), and ownership percentage details.',
                      Icons.description,
                      true,
                    ),
                  ],
                ),
              ),

              // Next Step Preview
              if (provider.numberOfShareholders > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Next: We\'ll help you determine visa requirements for ${provider.numberOfShareholders} shareholder${provider.numberOfShareholders > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    String title,
    String description,
    IconData icon,
    bool isHighlighted,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isHighlighted ? AppColors.primary : Colors.grey[600],
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isHighlighted ? AppColors.primary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
