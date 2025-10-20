import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../providers/company_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/step_indicator.dart';

class CompanyFormationScreen extends StatefulWidget {
  const CompanyFormationScreen({super.key});

  @override
  State<CompanyFormationScreen> createState() => _CompanyFormationScreenState();
}

class _CompanyFormationScreenState extends State<CompanyFormationScreen> {
  final PageController _pageController = PageController();
  final List<GlobalKey<FormBuilderState>> _formKeys = [
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
  ];
  
  int _currentStep = 0;
  final List<String> _steps = [
    'Company Type',
    'Company Details',
    'Shareholders',
    'Review & Submit',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState?.saveAndValidate() ?? false) {
      if (_currentStep < _steps.length - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitApplication();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitApplication() async {
    final provider = Provider.of<CompanyProvider>(context, listen: false);
    
    try {
      await provider.submitCompanyApplication();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Company formation application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Formation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Consumer<CompanyProvider>(
        builder: (context, provider, _) {
          return LoadingOverlay(
            isLoading: provider.isLoading,
            child: Column(
              children: [
                // Step Indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  child: StepIndicator(
                    currentStep: _currentStep,
                    steps: _steps,
                  ),
                ),
                
                // Form Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildCompanyTypeStep(),
                      _buildCompanyDetailsStep(),
                      _buildShareholdersStep(),
                      _buildReviewStep(),
                    ],
                  ),
                ),
                
                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: CustomButton(
                            text: 'Previous',
                            onPressed: _previousStep,
                            isOutlined: true,
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: _currentStep == _steps.length - 1 ? 'Submit' : 'Next',
                          onPressed: _nextStep,
                          isLoading: provider.isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompanyTypeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Company Type',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the type of company you want to establish in the UAE',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            // Company Type Options
            FormBuilderRadioGroup<String>(
              name: 'companyType',
              decoration: const InputDecoration(
                labelText: 'Company Type',
                border: InputBorder.none,
              ),
              options: [
                FormBuilderFieldOption(
                  value: 'llc',
                  child: _buildCompanyTypeCard(
                    'Limited Liability Company (LLC)',
                    'Most popular choice for foreign investors',
                    Icons.business,
                    Colors.blue,
                  ),
                ),
                FormBuilderFieldOption(
                  value: 'freezone',
                  child: _buildCompanyTypeCard(
                    'Free Zone Company',
                    '100% foreign ownership, tax benefits',
                    Icons.location_on,
                    Colors.green,
                  ),
                ),
                FormBuilderFieldOption(
                  value: 'branch',
                  child: _buildCompanyTypeCard(
                    'Branch Office',
                    'Extension of existing foreign company',
                    Icons.account_tree,
                    Colors.orange,
                  ),
                ),
                FormBuilderFieldOption(
                  value: 'representative',
                  child: _buildCompanyTypeCard(
                    'Representative Office',
                    'Marketing and promotion activities only',
                    Icons.campaign,
                    Colors.purple,
                  ),
                ),
              ],
              validators: [FormBuilderValidators.required()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyTypeCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKeys[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Provide the basic information about your company',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            CustomTextField(
              name: 'companyName',
              label: 'Company Name',
              hintText: 'Enter company name',
              prefixIcon: Icons.business,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(3),
              ],
            ),
            
            const SizedBox(height: 16),
            
            CustomTextField(
              name: 'tradeName',
              label: 'Trade Name',
              hintText: 'Enter trade name',
              prefixIcon: Icons.store,
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderDropdown<String>(
              name: 'businessActivity',
              decoration: const InputDecoration(
                labelText: 'Business Activity',
                prefixIcon: Icon(Icons.work),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(value: 'trading', child: Text('General Trading')),
                DropdownMenuItem(value: 'consulting', child: Text('Consulting Services')),
                DropdownMenuItem(value: 'technology', child: Text('Technology Services')),
                DropdownMenuItem(value: 'construction', child: Text('Construction')),
                DropdownMenuItem(value: 'healthcare', child: Text('Healthcare')),
                DropdownMenuItem(value: 'education', child: Text('Education')),
                DropdownMenuItem(value: 'hospitality', child: Text('Hospitality')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              validators: [FormBuilderValidators.required()],
            ),
            
            const SizedBox(height: 16),
            
            CustomTextField(
              name: 'capital',
              label: 'Authorized Capital (AED)',
              hintText: 'Enter capital amount',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.attach_money,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareholdersStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shareholders Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add shareholders and their ownership percentages',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            // Shareholder 1
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shareholder 1',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      name: 'shareholder1Name',
                      label: 'Full Name',
                      hintText: 'Enter full name',
                      prefixIcon: Icons.person,
                      validators: [FormBuilderValidators.required()],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      name: 'shareholder1Email',
                      label: 'Email',
                      hintText: 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      name: 'shareholder1Phone',
                      label: 'Phone Number',
                      hintText: '+971 50 123 4567',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone,
                      validators: [FormBuilderValidators.required()],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      name: 'shareholder1Percentage',
                      label: 'Ownership Percentage (%)',
                      hintText: 'Enter percentage',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.percent,
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(1),
                        FormBuilderValidators.max(100),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Submit',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your information before submitting',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          
          // Review Cards
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildReviewItem('Company Type', 'Limited Liability Company (LLC)'),
                  _buildReviewItem('Company Name', 'ABC Trading LLC'),
                  _buildReviewItem('Trade Name', 'ABC Trading'),
                  _buildReviewItem('Business Activity', 'General Trading'),
                  _buildReviewItem('Authorized Capital', 'AED 100,000'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shareholders',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildReviewItem('Shareholder 1', 'John Doe (60%)'),
                  _buildReviewItem('Shareholder 2', 'Jane Smith (40%)'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Terms and Conditions
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Important Information',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Processing time: 5-7 business days\n'
                    '• Required documents will be requested after submission\n'
                    '• Payment will be processed upon approval\n'
                    '• You will receive updates via email and SMS',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
