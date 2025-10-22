import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../providers/growth_state.dart';
import '../widgets/category_selection_step.dart';
import '../widgets/service_selection_step.dart';
import '../widgets/package_selection_step.dart';
import '../widgets/contact_information_step.dart';
import '../widgets/document_upload_step.dart';
import '../widgets/growth_review_step.dart';

class GrowthServicesFlowScreen extends StatelessWidget {
  const GrowthServicesFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GrowthState(),
      child: const GrowthServicesFlow(),
    );
  }
}

class GrowthServicesFlow extends StatefulWidget {
  const GrowthServicesFlow({super.key});

  @override
  State<GrowthServicesFlow> createState() => _GrowthServicesFlowState();
}

class _GrowthServicesFlowState extends State<GrowthServicesFlow> {
  int _currentStep = 0;
  final int _totalSteps = 6;

  final List<String> _stepTitles = [
    'Select Category',
    'Choose Service',
    'Select Package',
    'Contact Information',
    'Upload Documents',
    'Review & Confirm',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Growth Services'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<GrowthState>(
        builder: (context, growthState, child) {
          return Column(
            children: [
              // Progress Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _stepTitles[_currentStep],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: (_currentStep + 1) / _totalSteps,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),

              // Step Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStep(growthState),
                ),
              ),

              // Navigation Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back Button
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _previousStep,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                    if (_currentStep > 0) const SizedBox(width: 16),

                    // Next/Submit Button
                    Expanded(
                      flex: _currentStep == 0 ? 1 : 1,
                      child: ElevatedButton.icon(
                        onPressed: _canProceed(growthState) ? _nextStep : null,
                        icon: Icon(
                          _currentStep == _totalSteps - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                        ),
                        label: Text(
                          _currentStep == _totalSteps - 1
                              ? 'Submit Request'
                              : 'Next',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentStep(GrowthState growthState) {
    switch (_currentStep) {
      case 0:
        return CategorySelectionStep(
          formData: growthState.formData,
          onChanged: growthState.updateField,
        );
      case 1:
        return ServiceSelectionStep(
          formData: growthState.formData,
          onChanged: growthState.updateField,
        );
      case 2:
        return PackageSelectionStep(
          formData: growthState.formData,
          onChanged: growthState.updateField,
        );
      case 3:
        return ContactInformationStep(
          formData: growthState.formData,
          onChanged: growthState.updateField,
        );
      case 4:
        return DocumentUploadStep(
          formData: growthState.formData,
          onChanged: growthState.updateField,
        );
      case 5:
        return GrowthReviewStep(
          formData: growthState.formData,
          onChanged: growthState.updateField,
        );
      default:
        return const Center(child: Text('Invalid step'));
    }
  }

  bool _canProceed(GrowthState growthState) {
    return growthState.isStepComplete(_currentStep + 1);
  }

  void _nextStep() {
    if (_currentStep == _totalSteps - 1) {
      _submitForm();
    } else {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _submitForm() async {
    final growthState = Provider.of<GrowthState>(context, listen: false);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Submitting your request...'),
          ],
        ),
      ),
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pop(); // Close loading dialog

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Request Submitted!'),
            ],
          ),
          content: Text(
            'Your ${growthState.selectedService} request has been submitted successfully. '
            'Our team will contact you within ${growthState.getEstimatedTimeline()}.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
  }
}
