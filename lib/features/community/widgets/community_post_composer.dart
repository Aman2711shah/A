import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CommunityPostComposer extends StatefulWidget {
  const CommunityPostComposer({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  final Future<void> Function(String content) onSubmit;
  final bool isSubmitting;

  @override
  State<CommunityPostComposer> createState() => _CommunityPostComposerState();
}

class _CommunityPostComposerState extends State<CommunityPostComposer> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share an update with the community',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controller,
                maxLines: null,
                minLines: 3,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter something to share.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: widget.isSubmitting
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          await widget.onSubmit(_controller.text.trim());
                          if (mounted) {
                            _controller.clear();
                          }
                        },
                  icon: widget.isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(widget.isSubmitting ? 'Posting...' : 'Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
