import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../../core/services/firebase_firestore_service.dart';
import '../providers/company_setup_provider.dart';
import '../widgets/business_activity_step.dart';
import '../widgets/legal_structure_step.dart';
import '../widgets/shareholders_step.dart';
import '../widgets/visa_requirements_step.dart';
import '../widgets/office_space_step.dart';
import '../widgets/document_upload_step.dart';
import '../widgets/review_confirm_step.dart';
import '../../../config/theme/app_colors.dart';

class CompanySetupScreen extends StatelessWidget {
  const CompanySetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompanySetupProvider(
        firebaseAuth: FirebaseAuth.instance,
        firestoreService: FirestoreService(),
      ),
      child: const CompanySetupView(),
    );
  }
}

class CompanySetupView extends StatelessWidget {
  const CompanySetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Setup'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<CompanySetupProvider>(
        builder: (context, provider, child) {
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
                      'Step ${provider.currentStep + 1} of ${provider.totalSteps}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStepTitle(provider.currentStep),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: (provider.currentStep + 1) / provider.totalSteps,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),

              // Step Content
              Expanded(
                child: PageView(
                  controller: PageController(initialPage: provider.currentStep),
                  onPageChanged: provider.goToStep,
                  children: [
                    BusinessActivityStep(),
                    LegalStructureStep(),
                    ShareholdersStep(),
                    VisaRequirementsStep(),
                    OfficeSpaceStep(),
                    DocumentUploadStep(),
                    ReviewConfirmStep(),
                  ],
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
                    if (provider.currentStep > 0)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: provider.previousStep,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                    if (provider.currentStep > 0) const SizedBox(width: 16),

                    // Next/Submit Button
                    Expanded(
                      flex: provider.currentStep == 0 ? 1 : 1,
                      child: ElevatedButton.icon(
                        onPressed: provider.canProceed
                            ? () => _handleNextStep(context, provider)
                            : null,
                        icon: Icon(
                          provider.currentStep == provider.totalSteps - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                        ),
                        label: Text(
                          provider.currentStep == provider.totalSteps - 1
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

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Business Activity';
      case 1:
        return 'Legal Structure';
      case 2:
        return 'Shareholders';
      case 3:
        return 'Visa Requirements';
      case 4:
        return 'Office Space';
      case 5:
        return 'Documents';
      case 6:
        return 'Review & Confirm';
      default:
        return 'Company Setup';
    }
  }

  void _handleNextStep(
      BuildContext context, CompanySetupProvider provider) async {
    if (provider.currentStep == provider.totalSteps - 1) {
      // Submit form
      _showSubmitDialog(context, provider);
    } else {
      // Go to next step
      provider.nextStep();
    }
  }

  void _showSubmitDialog(BuildContext context, CompanySetupProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Submit Application'),
        content: const Text(
          'Are you sure you want to submit your company setup application? '
          'You will not be able to modify it after submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _submitApplication(context, provider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitApplication(
      BuildContext context, CompanySetupProvider provider) async {
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

    try {
      final applicationId = await provider.submitForm();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        provider.resetForm();
        _showSuccessDialog(context, applicationId);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        if (e is StateError) {
          _showAuthRequiredDialog(context);
        } else {
          _showErrorDialog(context);
        }
      }
    }
  }

  void _showSuccessDialog(BuildContext context, String applicationId) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your company setup application has been submitted successfully. '
              'Our team will review your application and contact you within 24 hours.',
            ),
            const SizedBox(height: 12),
            Text(
              'Application ID: $applicationId',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: applicationId));
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Application ID copied: $applicationId'),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: Text(
              'Copy ID',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
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

  void _showAuthRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text(
          'Please sign in to submit your application. Your progress has been saved locally.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Error'),
          ],
        ),
        content: const Text(
          'There was an error submitting your application. '
          'Please check your internet connection and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
