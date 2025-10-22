import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../providers/trade_license_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_overlay.dart';

class TradeLicenseScreen extends StatefulWidget {
  const TradeLicenseScreen({super.key});

  @override
  State<TradeLicenseScreen> createState() => _TradeLicenseScreenState();
}

class _TradeLicenseScreenState extends State<TradeLicenseScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _companyNameController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _licenseTypeController = TextEditingController();
  final _businessActivityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TradeLicenseProvider>(context, listen: false)
          .loadApplications();
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _tradeNameController.dispose();
    _licenseTypeController.dispose();
    _businessActivityController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final provider =
          Provider.of<TradeLicenseProvider>(context, listen: false);

      try {
        await provider.submitTradeLicenseApplication({
          'companyName': _companyNameController.text.trim(),
          'tradeName': _tradeNameController.text.trim(),
          'licenseType': _licenseTypeController.text.trim(),
          'businessActivity': _businessActivityController.text.trim(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Trade license application submitted successfully!'),
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
        title: const Text('Trade License'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Consumer<TradeLicenseProvider>(
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
              'Trade License Application',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Apply for a trade license to conduct business activities in the UAE',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _companyNameController,
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
              controller: _tradeNameController,
              label: 'Trade Name',
              hintText: 'Enter trade name',
              prefixIcon: Icons.store,
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            const SizedBox(height: 16),
            FormBuilderDropdown<String>(
              name: 'licenseType',
              decoration: const InputDecoration(
                labelText: 'License Type',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(
                    value: 'commercial', child: Text('Commercial License')),
                DropdownMenuItem(
                    value: 'professional', child: Text('Professional License')),
                DropdownMenuItem(
                    value: 'industrial', child: Text('Industrial License')),
                DropdownMenuItem(
                    value: 'tourism', child: Text('Tourism License')),
                DropdownMenuItem(
                    value: 'agricultural', child: Text('Agricultural License')),
              ],
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _businessActivityController,
              label: 'Business Activity',
              hintText: 'Describe your business activity',
              prefixIcon: Icons.work,
              maxLines: 3,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(10),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Submit Application',
              onPressed: _submitApplication,
              isLoading:
                  Provider.of<TradeLicenseProvider>(context, listen: false)
                      .isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsTab(TradeLicenseProvider provider) {
    if (provider.applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Applications Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Submit your first trade license application to get started',
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
                      application['companyName'] ?? 'N/A',
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
                  'Trade Name: ${application['tradeName'] ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'License Type: ${application['licenseType'] ?? 'N/A'}',
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
