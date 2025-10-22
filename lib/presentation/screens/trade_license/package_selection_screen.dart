import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/package_model.dart';
import '../../widgets/stepper/progress_stepper.dart';
import '../../widgets/cards/package_card.dart';

class PackageSelectionScreen extends StatefulWidget {
  const PackageSelectionScreen({super.key});

  @override
  State<PackageSelectionScreen> createState() => _PackageSelectionScreenState();
}

class _PackageSelectionScreenState extends State<PackageSelectionScreen> {
  int? _selectedPackageIndex;

  final List<PackageModel> _packages = [
    const PackageModel(
      id: '1',
      name: 'SME Flexi Desk',
      freeZone: 'RAKEZ',
      price: 15500,
      visaCount: 4,
      validityYears: 1,
      processingDays: '3-5',
      features: ['Flexi Desk', 'Basic Support', 'Online Portal Access'],
      isRecommended: false,
    ),
    const PackageModel(
      id: '2',
      name: 'Standard Office Package',
      freeZone: 'RAKEZ',
      price: 22000,
      visaCount: 5,
      validityYears: 1,
      processingDays: '3-5',
      features: ['Dedicated Office', 'Priority Support', 'Meeting Rooms'],
      isRecommended: true,
    ),
    const PackageModel(
      id: '3',
      name: 'SME All-In Serviced Office',
      freeZone: 'RAKEZ',
      price: 27000,
      visaCount: 5,
      validityYears: 1,
      processingDays: '3-5',
      features: ['Serviced Office', 'Premium Support', 'All Amenities'],
      isRecommended: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Trade License'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress Stepper
          const ProgressStepper(
            currentStep: 3,
            totalSteps: 5,
            completedSteps: [1, 2],
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Package',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the best package for your business',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Packages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final package = _packages[index];
                final isSelected = _selectedPackageIndex == index;
                
                return PackageCard(
                  package: package,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedPackageIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          
          // Bottom Navigation
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedPackageIndex != null
                        ? _handleNext
                        : null,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_selectedPackageIndex != null) {
      final selectedPackage = _packages[_selectedPackageIndex!];
      // TODO: Navigate to next screen with selected package
      debugPrint('Selected package: ${selectedPackage.name}');
    }
  }
}
