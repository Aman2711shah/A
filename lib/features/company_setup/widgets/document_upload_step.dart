import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_setup_provider.dart';
import '../../../config/theme/app_colors.dart';

class DocumentUploadStep extends StatelessWidget {
  const DocumentUploadStep({super.key});

  static const List<Map<String, dynamic>> requiredDocuments = [
    {
      'id': 'passport_copies',
      'title': 'Passport Copies',
      'description': 'Clear color copies of all shareholders\' passports',
      'icon': Icons.credit_card,
      'required': true,
      'examples': [
        'Passport bio page',
        'Visa page (if applicable)',
        'Entry stamp'
      ],
    },
    {
      'id': 'photos',
      'title': 'Passport Photos',
      'description': 'Recent passport-size photos (white background)',
      'icon': Icons.photo_camera,
      'required': true,
      'examples': [
        '3.5 x 4.5 cm',
        'White background',
        'Recent (within 6 months)'
      ],
    },
    {
      'id': 'noc_certificate',
      'title': 'NOC Certificate',
      'description': 'No Objection Certificate from current employer',
      'icon': Icons.work,
      'required': false,
      'examples': [
        'From HR department',
        'Notarized copy',
        'Valid for 6 months'
      ],
    },
    {
      'id': 'educational_certificates',
      'title': 'Educational Certificates',
      'description': 'Degree certificates and transcripts',
      'icon': Icons.school,
      'required': false,
      'examples': [
        'University degrees',
        'Professional certificates',
        'Transcripts'
      ],
    },
    {
      'id': 'experience_certificates',
      'title': 'Experience Certificates',
      'description': 'Work experience and employment letters',
      'icon': Icons.business_center,
      'required': false,
      'examples': [
        'Employment letters',
        'Experience certificates',
        'Salary certificates'
      ],
    },
    {
      'id': 'address_proof',
      'title': 'Address Proof',
      'description': 'UAE address verification documents',
      'icon': Icons.home,
      'required': true,
      'examples': ['Tenancy contract', 'Utility bills', 'Emirates ID'],
    },
    {
      'id': 'bank_statements',
      'title': 'Bank Statements',
      'description': 'Recent bank statements (last 3 months)',
      'icon': Icons.account_balance,
      'required': false,
      'examples': [
        'Personal bank statements',
        'Business bank statements',
        'Financial proof'
      ],
    },
    {
      'id': 'business_plan',
      'title': 'Business Plan',
      'description': 'Detailed business plan and projections',
      'icon': Icons.description,
      'required': false,
      'examples': [
        'Executive summary',
        'Financial projections',
        'Market analysis'
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanySetupProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Document Upload',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload the required documents for your company setup. Make sure all documents are clear and legible.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Progress Indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload Progress',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '${provider.uploadedDocuments.length} of ${_getRequiredDocumentCount()} required documents uploaded',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: provider.uploadedDocuments.length /
                          _getRequiredDocumentCount(),
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Documents List
              Expanded(
                child: ListView.builder(
                  itemCount: requiredDocuments.length,
                  itemBuilder: (context, index) {
                    final document = requiredDocuments[index];
                    return _buildDocumentCard(context, provider, document);
                  },
                ),
              ),

              // Upload All Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _showUploadAllDialog(context, provider),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Upload All Documents'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    CompanySetupProvider provider,
    Map<String, dynamic> document,
  ) {
    final isUploaded = provider.uploadedDocuments.contains(document['id']);
    final isRequired = document['required'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isUploaded ? Colors.green.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUploaded
                  ? Colors.green
                  : (isRequired ? Colors.red[300]! : Colors.grey[300]!),
              width: isUploaded ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUploaded
                          ? Colors.green
                          : (isRequired
                              ? Colors.red.withValues(alpha: 0.1)
                              : AppColors.primary.withValues(alpha: 0.1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isUploaded ? Icons.check : document['icon'],
                      color: isUploaded
                          ? Colors.white
                          : (isRequired ? Colors.red : AppColors.primary),
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
                                document['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isUploaded
                                      ? Colors.green[700]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (isRequired)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Required',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          document['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (isUploaded)
                    IconButton(
                      onPressed: () => provider.removeDocument(document['id']),
                      icon: const Icon(Icons.close),
                      color: Colors.red,
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showUploadDialog(context, provider, document),
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                ],
              ),

              // Examples
              if (document['examples'] != null && !isUploaded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Examples:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...document['examples'].map<Widget>((example) => Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[500],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  example,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],

              // Upload Status
              if (isUploaded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Document uploaded successfully',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
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

  int _getRequiredDocumentCount() {
    return requiredDocuments.where((doc) => doc['required'] == true).length;
  }

  void _showUploadDialog(
    BuildContext context,
    CompanySetupProvider provider,
    Map<String, dynamic> document,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload ${document['title']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document['description']),
            const SizedBox(height: 16),
            const Text(
              'File requirements:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• PDF, JPG, PNG formats only'),
            const Text('• Maximum file size: 10MB'),
            const Text('• Clear and legible images'),
            const Text('• Color scans preferred'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Simulate file upload
              provider.addDocument(document['id']);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${document['title']} uploaded successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.file_upload),
            label: const Text('Select File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadAllDialog(
    BuildContext context,
    CompanySetupProvider provider,
  ) {
    final unuploadedDocs = requiredDocuments
        .where((doc) => !provider.uploadedDocuments.contains(doc['id']))
        .toList();

    if (unuploadedDocs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All documents are already uploaded'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload All Documents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload ${unuploadedDocs.length} remaining documents:'),
            const SizedBox(height: 12),
            ...unuploadedDocs.take(3).map((doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${doc['title']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                )),
            if (unuploadedDocs.length > 3)
              Text('... and ${unuploadedDocs.length - 3} more'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Simulate uploading all documents
              for (final doc in unuploadedDocs) {
                provider.addDocument(doc['id']);
              }
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${unuploadedDocs.length} documents uploaded successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Upload All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
