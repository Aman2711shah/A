import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wazeet_app/features/company_setup/providers/company_setup_provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/services/business_activity_json_service.dart';
import '../models/business_activity_model.dart';

class BusinessActivityStep extends StatefulWidget {
  const BusinessActivityStep({super.key});

  @override
  State<BusinessActivityStep> createState() => _BusinessActivityStepState();
}

class _BusinessActivityStepState extends State<BusinessActivityStep> {
  List<BusinessActivityModel> _allActivities = [];
  List<BusinessActivityModel> _filteredActivities = [];
  List<String> _sectors = [];
  String _searchQuery = '';
  String? _selectedSector;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);
    try {
      final activities = await BusinessActivityJsonService.loadActivities();
      final sectors = await BusinessActivityJsonService.getSectors();
      setState(() {
        _allActivities = activities;
        _filteredActivities =
            activities.where((a) => a.isPopular).take(10).toList();
        _sectors = sectors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading activities: $e')),
        );
      }
    }
  }

  void _filterActivities() {
    setState(() {
      _filteredActivities = _allActivities.where((activity) {
        final matchesSearch = _searchQuery.isEmpty ||
            activity.activityName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            activity.sector.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesSector =
            _selectedSector == null || activity.sector == _selectedSector;
        return matchesSearch && matchesSector;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanySetupProvider>(
      builder: (context, provider, child) {
        if (_isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading activities...'),
                Text('(Loading over 1,900+ business activities)',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is your primary business activity?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the main activity your company will engage in. This helps us determine the appropriate license requirements.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search activities...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _filterActivities();
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterActivities();
                  });
                },
              ),
              const SizedBox(height: 12),

              // Sector Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedSector == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSector = null;
                          _filterActivities();
                        });
                      },
                    ),
                    ..._sectors.take(8).map((sector) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          label: Text(sector),
                          selected: _selectedSector == sector,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSector = selected ? sector : null;
                              _filterActivities();
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Results Count
              Text(
                '${_filteredActivities.length} activities found',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              // Activities List
              Expanded(
                child: _filteredActivities.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            const Text('No activities found'),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredActivities.length,
                        itemBuilder: (context, index) {
                          final activity = _filteredActivities[index];
                          return _buildActivityCard(
                            context,
                            provider,
                            activity,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    CompanySetupProvider provider,
    BusinessActivityModel activity,
  ) {
    final isSelected = provider.selectedActivity == activity.isicCode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 1,
        child: InkWell(
          onTap: () {
            provider.setSelectedActivity(activity.isicCode);
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
            child: Row(
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
                    _getIconData(activity.iconName),
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
                              activity.activityName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (activity.isPopular)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Popular',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activity.sector,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'oil_barrel':
        return Icons.oil_barrel;
      case 'computer':
        return Icons.computer;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'business_center':
        return Icons.business_center;
      case 'home_work':
        return Icons.home_work;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'hotel':
        return Icons.hotel;
      case 'precision_manufacturing':
        return Icons.precision_manufacturing;
      case 'account_balance':
        return Icons.account_balance;
      default:
        return Icons.business;
    }
  }
}
