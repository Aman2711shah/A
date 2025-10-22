import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../providers/visa_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_overlay.dart';

class VisaProcessingScreen extends StatefulWidget {
  const VisaProcessingScreen({super.key});

  @override
  State<VisaProcessingScreen> createState() => _VisaProcessingScreenState();
}

class _VisaProcessingScreenState extends State<VisaProcessingScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _employeeNameController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _positionController = TextEditingController();
  final _salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisaProvider>(context, listen: false).loadApplications();
    });
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _passportNumberController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final provider = Provider.of<VisaProvider>(context, listen: false);

      try {
        await provider.submitVisaApplication({
          'employeeName': _employeeNameController.text.trim(),
          'passportNumber': _passportNumberController.text.trim(),
          'position': _positionController.text.trim(),
          'salary': _salaryController.text.trim(),
          'visaType': 'Employment Visa',
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Visa application submitted successfully!'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Processing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Consumer<VisaProvider>(
        builder: (context, provider, _) {
          return LoadingOverlay(
            isLoading: provider.isLoading,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'New Application'),
                      Tab(text: 'My Applications'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildNewApplicationTab(),
                        _buildApplicationsTab(provider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewApplicationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visa Application',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Apply for employee visas to bring your team to the UAE',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 24),
            FormBuilderDropdown<String>(
              name: 'visaType',
              decoration: const InputDecoration(
                labelText: 'Visa Type',
                prefixIcon: Icon(Icons.work),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(
                    value: 'employment', child: Text('Employment Visa')),
                DropdownMenuItem(
                    value: 'investor', child: Text('Investor Visa')),
                DropdownMenuItem(
                    value: 'dependent', child: Text('Dependent Visa')),
                DropdownMenuItem(value: 'visit', child: Text('Visit Visa')),
              ],
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _employeeNameController,
              label: 'Employee Name',
              hintText: 'Enter full name',
              prefixIcon: Icons.person,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(3),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passportNumberController,
              label: 'Passport Number',
              hintText: 'Enter passport number',
              prefixIcon: Icons.credit_card,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(6),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _positionController,
              label: 'Position/Job Title',
              hintText: 'Enter job title',
              prefixIcon: Icons.work_outline,
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _salaryController,
              label: 'Monthly Salary (AED)',
              hintText: 'Enter salary amount',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.attach_money,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ],
            ),
            const SizedBox(height: 16),
            FormBuilderDropdown<String>(
              name: 'nationality',
              decoration: const InputDecoration(
                labelText: 'Nationality',
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(value: 'indian', child: Text('Indian')),
                DropdownMenuItem(value: 'pakistani', child: Text('Pakistani')),
                DropdownMenuItem(
                    value: 'bangladeshi', child: Text('Bangladeshi')),
                DropdownMenuItem(value: 'filipino', child: Text('Filipino')),
                DropdownMenuItem(value: 'egyptian', child: Text('Egyptian')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Submit Application',
              onPressed: _submitApplication,
              isLoading:
                  Provider.of<VisaProvider>(context, listen: false).isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsTab(VisaProvider provider) {
    if (provider.applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Visa Applications Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Submit your first visa application to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.applications.length,
      itemBuilder: (context, index) {
        final application = provider.applications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      application['employeeName'] ?? 'N/A',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(application['status'])
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        application['status'] ?? 'Unknown',
                        style: TextStyle(
                          color: _getStatusColor(application['status']),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Position: ${application['position'] ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Visa Type: ${application['visaType'] ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Passport: ${application['passportNumber'] ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Submitted: ${_formatDate(application['submittedAt'])}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'in review':
        return Colors.blue;
      case 'under process':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
