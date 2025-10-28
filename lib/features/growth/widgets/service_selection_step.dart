import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/theme/app_colors.dart';

class ServiceSelectionStep extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const ServiceSelectionStep({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  @override
  State<ServiceSelectionStep> createState() => _ServiceSelectionStepState();
}

class _ServiceSelectionStepState extends State<ServiceSelectionStep> {
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/growth_services.json');
      final List<dynamic> allServices = json.decode(jsonString);

      // Filter services by selected category
      final selectedCategory = widget.formData['selectedCategory'];
      List<Map<String, dynamic>> filteredServices = [];
      bool inCategory = false;

      for (var service in allServices) {
        if (service['Category'] == selectedCategory &&
            service['Premium Charges (AED)'] == null) {
          inCategory = true;
          continue;
        }

        if (inCategory) {
          if (service['Premium Charges (AED)'] != null) {
            filteredServices.add(Map<String, dynamic>.from(service));
          } else {
            // New category started, stop collecting
            break;
          }
        }
      }

      setState(() {
        _services = filteredServices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'No services found',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.formData['selectedCategory'] ?? '',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the specific service you need. Each service includes premium and standard packages.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: _services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(_services[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final isSelected =
        widget.formData['selectedService'] == service['Category'];
    final serviceName = service['Category'] ?? 'Unknown Service';
    final premiumPrice = service['Premium Charges (AED)'] ?? 0;
    final standardPrice = service['Standard Charges (AED)'] ?? 0;
    final premiumTimeline = service['Premium Timeline'] ?? 'N/A';
    final standardTimeline = service['Standard Timeline'] ?? 'N/A';
    final documents = service['Documents Required'] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 1,
        child: InkWell(
          onTap: () {
            widget.onChanged('selectedService', service['Category']);
            widget.onChanged('selectedServiceData', service);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        serviceName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
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

                // Pricing Comparison
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Premium',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AED $premiumPrice',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              premiumTimeline,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.borderSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Standard',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AED $standardPrice',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              standardTimeline,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Documents Required
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.description,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Required: $documents',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondary,
                          ),
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
}
