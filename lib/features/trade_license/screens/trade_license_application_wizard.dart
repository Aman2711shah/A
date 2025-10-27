import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/freezone_model.dart';
import '../models/freezone_package_model.dart';
import '../providers/trade_license_provider.dart';
import '../../../core/services/freezone_package_service.dart';
import 'freezone_selection_screen.dart';

class TradeLicenseApplicationWizard extends StatefulWidget {
  const TradeLicenseApplicationWizard({super.key});

  @override
  State<TradeLicenseApplicationWizard> createState() =>
      _TradeLicenseApplicationWizardState();
}

class _TradeLicenseApplicationWizardState
    extends State<TradeLicenseApplicationWizard> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Step 1: Jurisdiction
  String? _selectedJurisdiction;

  // Step 2: Freezone/Mainland
  FreezoneModel? _selectedFreezone;

  // Step 3: Package
  String? _selectedPackage;
  FreezonePackageModel? _selectedPackageModel;
  List<FreezonePackageModel> _availablePackages = [];
  bool _loadingPackages = false;

  // Step 4: Documents (checkboxes)
  final Map<String, bool> _documents = {
    'Passport Copy': false,
    'Emirates ID': false,
    'Visa Copy': false,
    'Proof of Address': false,
    'Business Plan': false,
    'NOC (if applicable)': false,
  };

  // Step 5: Contact Details
  final _contactFormKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _tradeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _companyNameController.dispose();
    _tradeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 4) {
        setState(() {
          _currentStep++;
        });
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        // Load packages when moving to package step
        if (_currentStep == 2) {
          _loadPackagesForSelectedFreezone();
        }
      } else {
        _submitApplication();
      }
    }
  }

  Future<void> _loadPackagesForSelectedFreezone() async {
    if (_selectedFreezone?.jsonName == null) {
      setState(() {
        _availablePackages = [];
        _loadingPackages = false;
      });
      return;
    }

    setState(() {
      _loadingPackages = true;
    });

    try {
      final packages = await FreezonePackageService.instance
          .getPackagesByFreezone(_selectedFreezone!.jsonName!);
      setState(() {
        _availablePackages = packages;
        _loadingPackages = false;
      });
    } catch (e) {
      setState(() {
        _availablePackages = [];
        _loadingPackages = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading packages: $e')),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_selectedJurisdiction == null) {
          _showError('Please select a jurisdiction');
          return false;
        }
        return true;
      case 1:
        if (_selectedFreezone == null) {
          _showError('Please select a freezone or mainland option');
          return false;
        }
        return true;
      case 2:
        if (_selectedPackage == null) {
          _showError('Please select a package');
          return false;
        }
        return true;
      case 3:
        final selectedDocs =
            _documents.values.where((selected) => selected).length;
        if (selectedDocs == 0) {
          _showError('Please check at least one document');
          return false;
        }
        return true;
      case 4:
        if (!_contactFormKey.currentState!.validate()) {
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _submitApplication() async {
    final provider = Provider.of<TradeLicenseProvider>(context, listen: false);

    try {
      await provider.submitTradeLicenseApplication({
        'jurisdiction': _selectedJurisdiction,
        'freezone': _selectedFreezone?.name,
        'freezoneId': _selectedFreezone?.id,
        'freezoneEmirate': _selectedFreezone?.emirate,
        'package': _selectedPackage,
        'companyName': _companyNameController.text.trim(),
        'tradeName': _tradeNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'documents':
            _documents.entries.where((e) => e.value).map((e) => e.key).toList(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop && _currentStep > 0) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Apply for Trade License'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_currentStep > 0) {
                _previousStep();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Column(
          children: [
            // Step Indicator
            _buildStepIndicator(colorScheme, theme),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildJurisdictionStep(colorScheme, theme),
                  _buildFreezoneStep(colorScheme, theme),
                  _buildPackageStep(colorScheme, theme),
                  _buildDocumentsStep(colorScheme, theme),
                  _buildContactStep(colorScheme, theme),
                ],
              ),
            ),

            // Navigation Buttons
            _buildNavigationButtons(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ColorScheme colorScheme, ThemeData theme) {
    final steps = [
      'Jurisdiction',
      'Freezone',
      'Package',
      'Documents',
      'Submit'
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step Progress Bar
          Row(
            children: List.generate(5, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < 4) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Step Numbers and Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? colorScheme.primary
                            : isCurrent
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                size: 16,
                                color: colorScheme.onPrimary,
                              )
                            : Text(
                                '${index + 1}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isCurrent
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[index],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isCurrent
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildJurisdictionStep(ColorScheme colorScheme, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Jurisdiction',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose between Mainland or Free Zone for your business',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Mainland Option
          _buildJurisdictionCard(
            title: 'Mainland (DED)',
            description:
                'Trade anywhere in UAE, access local market, government contracts eligible',
            icon: Icons.location_city,
            color: Colors.blue,
            isSelected: _selectedJurisdiction == 'Mainland',
            onTap: () => setState(() => _selectedJurisdiction = 'Mainland'),
            features: [
              'No geographical restrictions',
              'Government tender participation',
              'Requires local sponsor or service agent',
            ],
          ),

          const SizedBox(height: 16),

          // Free Zone Option
          _buildJurisdictionCard(
            title: 'Free Zone',
            description:
                '100% foreign ownership, zero taxes, modern infrastructure, global business activities',
            icon: Icons.business,
            color: Colors.green,
            isSelected: _selectedJurisdiction == 'Free Zone',
            onTap: () => setState(() => _selectedJurisdiction = 'Free Zone'),
            features: [
              '100% foreign ownership',
              'Zero corporate and personal tax',
              'Restrictions on UAE mainland trading',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJurisdictionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    required List<String> features,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 13),
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

  Widget _buildFreezoneStep(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedJurisdiction == 'Free Zone'
                    ? 'Select Free Zone'
                    : 'Select Mainland Emirate',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedJurisdiction == 'Free Zone'
                    ? 'Choose from 30+ free zones across the UAE'
                    : 'Choose the emirate for your mainland license',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _selectedFreezone == null
              ? FreezoneSelectionScreen(
                  initialType: _selectedJurisdiction == 'Free Zone'
                      ? FreezoneType.freeZone
                      : FreezoneType.mainland,
                  onFreezoneSelected: (freezone) {
                    setState(() {
                      _selectedFreezone = freezone;
                    });
                    _nextStep();
                  },
                )
              : _buildSelectedFreezone(colorScheme, theme),
        ),
      ],
    );
  }

  Widget _buildSelectedFreezone(ColorScheme colorScheme, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected:',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.primary, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedFreezone!.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _selectedFreezone!.icon,
                          color: _selectedFreezone!.color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedFreezone!.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _selectedFreezone!.emirate,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFreezone!.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedFreezone = null;
                        _currentStep = 1;
                      });
                      _pageController.jumpToPage(1);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Change Selection'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageStep(ColorScheme colorScheme, ThemeData theme) {
    // Show loading state
    if (_loadingPackages) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading packages...'),
          ],
        ),
      );
    }

    // Show message if no packages available
    if (_availablePackages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 64,
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No packages available',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedFreezone?.jsonName == null
                    ? 'Package information not available for this freezone yet.'
                    : 'Please contact us for pricing details.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Could open contact form or link
                },
                icon: const Icon(Icons.phone),
                label: const Text('Contact Us'),
              ),
            ],
          ),
        ),
      );
    }

    // Group packages by tenure for better organization
    final packagesByTenure = <int, List<FreezonePackageModel>>{};
    for (final package in _availablePackages) {
      packagesByTenure.putIfAbsent(package.tenureYears, () => []).add(package);
    }
    final tenureOptions = packagesByTenure.keys.toList()..sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Package',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Packages available for ${_selectedFreezone!.name}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Show packages grouped by tenure
          ...tenureOptions.map((tenure) {
            final packages = packagesByTenure[tenure]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, top: 8),
                  child: Text(
                    '${tenure == 1 ? '1 Year' : '$tenure Years'} Packages',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                ...packages.map((package) {
                  final isSelected = _selectedPackageModel?.packageName ==
                          package.packageName &&
                      _selectedPackageModel?.tenureYears == package.tenureYears;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildRealPackageCard(
                      package: package,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedPackageModel = package;
                          _selectedPackage = package.packageName;
                        });
                      },
                      colorScheme: colorScheme,
                      theme: theme,
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRealPackageCard({
    required FreezonePackageModel package,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    // Calculate pricing display
    final basePrice = package.priceAED.toStringAsFixed(0);
    final totalWithVisa = package.totalCostWithVisa.toStringAsFixed(0);
    final hasVisas = package.visasIncluded > 0;

    // Choose icon and color based on package name
    IconData icon = Icons.business_center;
    Color color = colorScheme.primary;

    if (package.packageName.toLowerCase().contains('starter') ||
        package.packageName.toLowerCase().contains('basic')) {
      icon = Icons.rocket_launch;
      color = Colors.blue;
    } else if (package.packageName.toLowerCase().contains('premium') ||
        package.packageName.toLowerCase().contains('corporate')) {
      icon = Icons.corporate_fare;
      color = Colors.purple;
    } else if (package.packageName.toLowerCase().contains('media')) {
      icon = Icons.videocam;
      color = Colors.orange;
    } else if (package.packageName.toLowerCase().contains('trade') ||
        package.packageName.toLowerCase().contains('trading')) {
      icon = Icons.shopping_cart;
      color = Colors.green;
    }

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.packageName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          hasVisas
                              ? 'AED $totalWithVisa (with visas)'
                              : 'AED $basePrice',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (hasVisas)
                          Text(
                            'Base: AED $basePrice',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Package details
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.business,
                    label: package.activitiesAllowed,
                    color: color,
                  ),
                  _buildInfoChip(
                    icon: Icons.people,
                    label: package.shareholdersAllowed,
                    color: color,
                  ),
                  if (hasVisas)
                    _buildInfoChip(
                      icon: Icons.badge,
                      label:
                          '${package.visasIncluded} Visa${package.visasIncluded > 1 ? 's' : ''}',
                      color: color,
                    ),
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: package.displayTenure,
                    color: color,
                  ),
                ],
              ),

              // Additional fees breakdown (expandable)
              if (hasVisas) ...[
                const SizedBox(height: 12),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Visa Fee Breakdown',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    _buildFeeRow(
                        'Immigration Card', package.immigrationCardFee),
                    _buildFeeRow('E-Channel Fee', package.eChannelFee),
                    _buildFeeRow('Visa Cost', package.visaCostAED),
                    _buildFeeRow('Medical Fee', package.medicalFee),
                    _buildFeeRow('Emirates ID', package.emiratesIdFee),
                    _buildFeeRow('Status Change', package.changeOfStatusFee),
                    const Divider(),
                    _buildFeeRow(
                      'Total per Visa',
                      package.immigrationCardFee +
                          package.eChannelFee +
                          package.visaCostAED +
                          package.medicalFee +
                          package.emiratesIdFee +
                          package.changeOfStatusFee,
                      isBold: true,
                    ),
                  ],
                ),
              ],

              // Other notes if available
              if (package.otherNotes != null &&
                  package.otherNotes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          package.otherNotes!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildFeeRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'AED ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsStep(ColorScheme colorScheme, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Documents',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the documents you have ready to upload',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: _documents.keys.map((docName) {
              return CheckboxListTile(
                title: Text(docName),
                value: _documents[docName],
                onChanged: (bool? value) {
                  setState(() {
                    _documents[docName] = value ?? false;
                  });
                },
                activeColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactStep(ColorScheme colorScheme, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _contactFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Details',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your company and contact information',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                prefixIcon: const Icon(Icons.business),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter company name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tradeNameController,
              decoration: InputDecoration(
                labelText: 'Trade Name',
                prefixIcon: const Icon(Icons.store),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter trade name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                if (!value.contains('@')) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Jurisdiction', _selectedJurisdiction ?? ''),
                  _buildSummaryRow('Location', _selectedFreezone?.name ?? ''),
                  _buildSummaryRow('Package', _selectedPackage ?? ''),
                ],
              ),
            ),
          ],
        ),
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
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: _currentStep == 0 ? 1 : 2,
              child: FilledButton(
                onPressed: _nextStep,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentStep == 4 ? 'Submit Application' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
