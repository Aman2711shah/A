import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/services/firebase_storage_service.dart';
import '../../services/models/service_catalog.dart';
import '../../services/providers/services_provider.dart';

class QuoteRequestForm extends StatefulWidget {
  const QuoteRequestForm({super.key});

  @override
  State<QuoteRequestForm> createState() => _QuoteRequestFormState();
}

class _QuoteRequestFormState extends State<QuoteRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // Lazily initialize to avoid requiring a Firebase app during widget build in tests.
  FirebaseStorageService? _storage;
  bool _uploading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  List<String> _parseRequiredDocs(SubService sub) {
    final raw = sub.documents;
    if (raw.trim().isEmpty) return const [];
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _pickAndUpload({required String key}) async {
    final provider = context.read<ServicesProvider>();
    final user = FirebaseAuth.instance.currentUser;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: kIsWeb,
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext = (file.extension ?? 'bin').toLowerCase();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final owner = user?.uid ?? 'anonymous';
    final storagePath = 'service_quotes/$owner/$key/$fileName';

    setState(() => _uploading = true);
    try {
      String url;
      // Lazily create storage instance only when needed (prevents Firebase init during tests)
      final storage = _storage ??= FirebaseStorageService();
      if (kIsWeb) {
        final Uint8List bytes = file.bytes!;
        final contentType = ext == 'pdf' ? 'application/pdf' : 'image/$ext';
        url = await storage.uploadFileFromBytes(
          bytes: bytes,
          storagePath: storagePath,
          contentType: contentType,
          onProgress: (p) {},
        );
      } else {
        final path = file.path!;
        url = await storage.uploadFile(
          filePath: path,
          storagePath: storagePath,
          onProgress: (p) {},
        );
      }
      provider.addUploadedDocument(key, url);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$key uploaded'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServicesProvider>();
    final sub = provider.selectedSubService;
    if (sub == null) {
      return const SizedBox.shrink();
    }
    final requiredDocs = _parseRequiredDocs(sub);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request a Quote',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your details and upload the required documents to get a tailored quote.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            if (requiredDocs.isNotEmpty) ...[
              const Text(
                'Documents required',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...requiredDocs.map((doc) {
                final key = doc;
                final uploadedUrl = provider.uploadedDocuments[key];
                final uploaded = uploadedUrl != null && uploadedUrl.isNotEmpty;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: uploaded
                        ? Colors.green.withValues(alpha: 0.08)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: uploaded ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        uploaded
                            ? Icons.check_circle
                            : Icons.description_outlined,
                        color: uploaded ? Colors.green : AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          doc,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: uploaded
                                ? Colors.green.shade800
                                : Colors.black87,
                          ),
                        ),
                      ),
                      if (uploaded)
                        IconButton(
                          onPressed: () => provider.removeUploadedDocument(key),
                          icon: const Icon(Icons.close, color: Colors.red),
                          tooltip: 'Remove',
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _uploading
                              ? null
                              : () => _pickAndUpload(key: key),
                          icon: const Icon(Icons.upload),
                          label: const Text('Upload'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().length < 7)
                        ? 'Enter a valid number'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final email = v?.trim() ?? '';
                      final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
                      return ok ? null : 'Enter a valid email';
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: provider.isSubmittingQuote
                        ? null
                        : () async {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            final data = {
                              'name': _nameCtrl.text.trim(),
                              'phone': _phoneCtrl.text.trim(),
                              'email': _emailCtrl.text.trim(),
                            };
                            await provider.submitQuoteRequest(data);
                            if (mounted) {
                              final err = provider.submitError;
                              if (err != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed: $err'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Quote request submitted'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                    icon: provider.isSubmittingQuote
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      provider.isSubmittingQuote
                          ? 'Submitting...'
                          : 'Submit Quote Request',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'You can attach additional documents later during onboarding.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
