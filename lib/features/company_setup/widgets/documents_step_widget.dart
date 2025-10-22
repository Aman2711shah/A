import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class DocumentsStepWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const DocumentsStepWidget({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> requiredDocuments = [
    {
      'id': 'passport_copies',
      'title': 'Passport Copies',
      'description': 'Clear color copies of all shareholders\' passports',
      'icon': Icons.credit_card,
      'required': true,
    },
    {
      'id': 'photos',
      'title': 'Passport Photos',
      'description': 'Recent passport-size photos (white background)',
      'icon': Icons.photo_camera,
      'required': true,
    },
    {
      'id': 'noc_certificate',
      'title': 'NOC Certificate',
      'description': 'No Objection Certificate from current employer',
      'icon': Icons.work,
      'required': false,
    },
    {
      'id': 'educational_certificates',
      'title': 'Educational Certificates',
      'description': 'Degree certificates and transcripts',
      'icon': Icons.school,
      'required': false,
    },
    {
      'id': 'address_proof',
      'title': 'Address Proof',
      'description': 'UAE address verification documents',
      'icon': Icons.home,
      'required': true,
    },
    {
      'id': 'business_plan',
      'title': 'Business Plan',
      'description': 'Detailed business plan and projections',
      'icon': Icons.description,
      'required': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final uploadedDocuments =
        (formData['uploadedDocuments'] as List<String>?) ?? [];

    return Column(
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
                          '${uploadedDocuments.length} of ${_getRequiredDocumentCount()} required documents uploaded',
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
                value: uploadedDocuments.length / _getRequiredDocumentCount(),
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
              return _buildDocumentCard(document, uploadedDocuments);
            },
          ),
        ),

        // Upload All Button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16),
          child: ElevatedButton.icon(
            onPressed: () => _uploadAllDocuments(uploadedDocuments),
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
    );
  }

  Widget _buildDocumentCard(
    Map<String, dynamic> document,
    List<String> uploadedDocuments,
  ) {
    final isUploaded = uploadedDocuments.contains(document['id']);
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
                      onPressed: () => _removeDocument(document['id']),
                      icon: const Icon(Icons.close),
                      color: Colors.red,
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _uploadDocument(document['id']),
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

  void _uploadDocument(String documentId) {
    final uploadedDocuments =
        (formData['uploadedDocuments'] as List<String>?) ?? [];
    if (!uploadedDocuments.contains(documentId)) {
      final newList = List<String>.from(uploadedDocuments)..add(documentId);
      onChanged('uploadedDocuments', newList);
    }
  }

  void _removeDocument(String documentId) {
    final uploadedDocuments =
        (formData['uploadedDocuments'] as List<String>?) ?? [];
    final newList = List<String>.from(uploadedDocuments)..remove(documentId);
    onChanged('uploadedDocuments', newList);
  }

  void _uploadAllDocuments(List<String> currentDocuments) {
    final allDocumentIds =
        requiredDocuments.map((doc) => doc['id'] as String).toList();
    onChanged('uploadedDocuments', allDocumentIds);
  }
}
