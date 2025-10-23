import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../providers/setup_state.dart';
import '../widgets/activity_step_widget.dart';
import '../widgets/legal_structure_step_widget.dart';
import '../widgets/shareholders_step_widget.dart';
import '../widgets/visas_step_widget.dart';
import '../widgets/office_step_widget.dart';
import '../widgets/documents_step_widget.dart';
import '../widgets/review_step_widget.dart';
import '../widgets/freezone_recommendations_step_widget.dart';

class CompanySetupTab extends StatefulWidget {
  const CompanySetupTab({super.key});

  @override
  State<CompanySetupTab> createState() => _CompanySetupTabState();
}

class _CompanySetupTabState extends State<CompanySetupTab> {
  int _currentStep = 0;
  final int _totalSteps = 8;

  final List<String> _stepTitles = [
    'Business Activity',
    'Legal Structure',
    'Shareholders',
    'Visa Requirements',
    'Office Space',
    'Documents',
    'Review & Submit',
    'Choose Freezone'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Setup'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<SetupState>(
        builder: (context, setupState, child) {
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
                  child: _buildCurrentStep(setupState),
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
                        onPressed: _canProceed(setupState) ? _nextStep : null,
                        icon: Icon(
                          _currentStep == _totalSteps - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                        ),
                        label: Text(
                          _currentStep == _totalSteps - 1
                              ? 'Submit Application'
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

  Widget _buildCurrentStep(SetupState setupState) {
    switch (_currentStep) {
      case 0:
        return ActivityStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      case 1:
        return LegalStructureStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      case 2:
        return ShareholdersStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      case 3:
        return VisasStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      case 4:
        return OfficeStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      case 5:
        return DocumentsStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      case 6:
        return ReviewStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      case 7:
        return FreezoneRecommendationsStepWidget(
          formData: setupState.formData,
          onChanged: setupState.updateField,
        );
      default:
        return const Center(child: Text('Invalid step'));
    }
  }

  bool _canProceed(SetupState setupState) {
    switch (_currentStep) {
      case 0: // Activity
        return setupState.businessActivity != null;
      case 1: // Legal Structure
        return setupState.legalStructure != null;
      case 2: // Shareholders
        return setupState.shareholders != null && setupState.shareholders! > 0;
      case 3: // Visas
        return setupState.visaType != null;
      case 4: // Office
        return setupState.officeType != null;
      case 5: // Documents
        return setupState.uploadedDocuments.isNotEmpty;
      case 6: // Review
        return setupState.agreedToTerms;
      case 7: // Freezone Selection
        return setupState.selectedFreezone != null;
      default:
        return false;
    }
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
    final setupState = Provider.of<SetupState>(context, listen: false);

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
            Text('Submitting your application...'),
          ],
        ),
      ),
    );

    // Simulate API call (in real app, send setupState.toJson())
    await Future.delayed(const Duration(seconds: 2));

    // Ensure the widget is still mounted before using context after an async gap
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
            Text('Success!'),
          ],
        ),
        content: const Text(
          'Your company setup application has been submitted successfully. '
          'Our team will review your application and contact you within 24 hours.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _resetForm(setupState); // Reset form for new application
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

  void _resetForm(SetupState setupState) {
    setState(() {
      _currentStep = 0;
    });
    setupState.reset();
  }
}
