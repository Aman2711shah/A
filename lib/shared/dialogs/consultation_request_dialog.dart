import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/firebase_firestore_service.dart';
import '../../config/theme/app_colors.dart';

Future<void> showConsultationRequestDialog(
  BuildContext context, {
  String? topic,
}) {
  final rootContext = context;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController(text: topic ?? '');
  final formKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    nameController.text = user.displayName ?? '';
    emailController.text = user.email ?? '';
  }

  ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (modalContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Book a Consultation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'How can we help?',
                  border: OutlineInputBorder(),
                ),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: isSubmitting,
                builder: (_, submitting, __) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                          onPressed: submitting
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              isSubmitting.value = true;
                              try {
                                final firestore = FirestoreService();
                                final payload = {
                                  'userId': user?.uid,
                                  'name': nameController.text.trim(),
                                  'email': emailController.text.trim(),
                                  'phone': phoneController.text.trim(),
                                  'notes': notesController.text.trim(),
                                };
                                final requestId = await firestore
                                    .createConsultationRequest(payload);
                                if (rootContext.mounted) {
                                  Navigator.of(modalContext).pop();
                                  ScaffoldMessenger.of(rootContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Consultation request submitted (ID: $requestId)',
                                      ),
                                    ),
                                  );
                                }
                              } catch (_) {
                                if (rootContext.mounted) {
                                  ScaffoldMessenger.of(rootContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to submit request. Please try again.'),
                                    ),
                                  );
                                }
                              } finally {
                                isSubmitting.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Request'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
