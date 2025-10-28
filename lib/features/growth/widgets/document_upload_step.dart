import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class DocumentUploadStep extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String key, dynamic value) onChanged;

  const DocumentUploadStep({
    super.key,
    required this.formData,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final serviceData =
        formData['selectedServiceData'] as Map<String, dynamic>?;
    final documentsRequired = serviceData?['Documents Required'] ?? 'N/A';
    final uploadedDocs = (formData['uploadedDocuments'] as List<String>?) ?? [];

    // Parse required documents
    final List<String> docList = documentsRequired
        .toString()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != 'N/A')
        .toList();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Documents',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload the required documents for your selected service. Make sure all documents are clear and legible.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
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
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Progress',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          '${uploadedDocs.length} of ${docList.length} documents uploaded',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value:
                    docList.isEmpty ? 0 : uploadedDocs.length / docList.length,
                backgroundColor: colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Documents List
        Expanded(
          child: ListView.builder(
            itemCount: docList.length,
            itemBuilder: (context, index) {
              final docName = docList[index];
              return _buildDocumentCard(context, docName, uploadedDocs);
            },
          ),
        ),

        // Upload All Button
        if (docList.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
              onPressed: () => _uploadAllDocuments(docList),
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Upload All Documents (Demo)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDocumentCard(
      BuildContext context, String docName, List<String> uploadedDocs) {
    final isUploaded = uploadedDocs.contains(docName);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final successColor = AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isUploaded
            ? successColor.withValues(alpha: 0.1)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUploaded
                  ? successColor
                  : colorScheme.outlineVariant.withValues(alpha: 0.6),
              width: isUploaded ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUploaded
                      ? successColor
                      : colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isUploaded ? Icons.check : Icons.description,
                  color:
                      isUploaded ? colorScheme.onPrimary : colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      docName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            isUploaded ? successColor : colorScheme.onSurface,
                      ),
                    ),
                    if (isUploaded) const SizedBox(height: 4),
                    if (isUploaded)
                      Text(
                        'Uploaded successfully',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isUploaded)
                IconButton(
                  onPressed: () => _removeDocument(docName),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.error,
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => _uploadDocument(docName),
                  icon: Icon(
                    Icons.upload,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                  label: Text(
                    'Upload',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadDocument(String docName) {
    final uploadedDocs = (formData['uploadedDocuments'] as List<String>?) ?? [];
    if (!uploadedDocs.contains(docName)) {
      final newList = List<String>.from(uploadedDocs)..add(docName);
      onChanged('uploadedDocuments', newList);
    }
  }

  void _removeDocument(String docName) {
    final uploadedDocs = (formData['uploadedDocuments'] as List<String>?) ?? [];
    final newList = List<String>.from(uploadedDocs)..remove(docName);
    onChanged('uploadedDocuments', newList);
  }

  void _uploadAllDocuments(List<String> docList) {
    onChanged('uploadedDocuments', List<String>.from(docList));
  }
}
