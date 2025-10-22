import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/utils/freezone_utils.dart';

class FreezoneRecommendationsStepWidget extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const FreezoneRecommendationsStepWidget({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  @override
  State<FreezoneRecommendationsStepWidget> createState() =>
      _FreezoneRecommendationsStepWidgetState();
}

class _FreezoneRecommendationsStepWidgetState
    extends State<FreezoneRecommendationsStepWidget> {
  List<Map<String, dynamic>>? _recommendations;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load all freezones
      final allZones = await loadFreezones();

      // Filter based on user input
      final filteredZones = filterFreezones(allZones, widget.formData);

      setState(() {
        _recommendations =
            filteredZones.take(5).toList(); // Top 5 recommendations
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load freezone recommendations: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Freezone Recommendations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Based on your requirements, here are the best freezone options for your business.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        if (_isLoading)
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading freezone recommendations...'),
                ],
              ),
            ),
          )
        else if (_error != null)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadRecommendations,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if (_recommendations?.isEmpty ?? true)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No freezone recommendations found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your requirements or contact our team for personalized assistance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _recommendations!.length,
              itemBuilder: (context, index) {
                final recommendation = _recommendations![index];
                return _buildRecommendationCard(recommendation, index);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendationCard(
      Map<String, dynamic> recommendation, int index) {
    final freezone = recommendation['Freezone'] ?? 'Unknown Freezone';
    final packageName = recommendation['Package Name'] ?? 'Standard Package';
    final price = recommendation['Price (AED)'];
    final tenure = recommendation['Tenure (Years)'];
    final visas = recommendation['No. of Visas Included'] ?? 0;
    final activities =
        recommendation['No. of Activities Allowed'] ?? 'Multiple';

    final isSelected = widget.formData['selectedFreezone'] == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _selectFreezone(index, recommendation),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          freezone,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          packageName,
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

              // Price
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'AED ${_formatPrice(price)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    if (tenure != null)
                      Text(
                        'for $tenure year${tenure > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Features
              Row(
                children: [
                  Expanded(
                    child: _buildFeature(
                      Icons.business,
                      'Activities',
                      activities.toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildFeature(
                      Icons.card_membership,
                      'Visas',
                      visas.toString(),
                    ),
                  ),
                  if (tenure != null)
                    Expanded(
                      child: _buildFeature(
                        Icons.schedule,
                        'Duration',
                        '$tenure year${tenure > 1 ? 's' : ''}',
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Additional costs note
              if (recommendation['Other Costs / Notes'] != null)
                Container(
                  width: double.infinity,
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
                          recommendation['Other Costs / Notes'],
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
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatPrice(dynamic price) {
    if (price is num) {
      return price.toStringAsFixed(0);
    }
    return price?.toString() ?? '0';
  }

  void _selectFreezone(int index, Map<String, dynamic> freezone) {
    widget.onChanged('selectedFreezone', index);
    widget.onChanged('selectedFreezoneData', freezone);
  }
}
