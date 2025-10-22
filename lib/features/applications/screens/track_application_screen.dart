import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/services/firebase_firestore_service.dart';
import '../../../config/theme/app_colors.dart';

class TrackApplicationScreen extends StatefulWidget {
  static const String routeName = '/applications/track';

  const TrackApplicationScreen({super.key});

  @override
  State<TrackApplicationScreen> createState() =>
      _TrackApplicationScreenState();
}

class _TrackApplicationScreenState extends State<TrackApplicationScreen> {
  final _applicationIdController = TextEditingController();
  final _firestoreService = FirestoreService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _applicationData;
  String? _applicationId;

  @override
  void dispose() {
    _applicationIdController.dispose();
    super.dispose();
  }

  Future<void> _handleTrack() async {
    final applicationId = _applicationIdController.text.trim();
    if (applicationId.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a valid application ID.';
        _applicationData = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _applicationData = null;
    });

    try {
      final snapshot = await _firestoreService.getApplication(applicationId);
      if (!snapshot.exists) {
        setState(() {
          _errorMessage = 'No application found with this ID.';
        });
      } else {
        setState(() {
          _applicationData =
              snapshot.data() as Map<String, dynamic>? ?? <String, dynamic>{};
          _applicationId = snapshot.id;
        });
      }
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unable to fetch application.';
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Application'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your application ID to view the latest status.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _applicationIdController,
              decoration: const InputDecoration(
                labelText: 'Application ID',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _handleTrack(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleTrack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Track Application'),
              ),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_applicationData != null) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final status = _applicationData?['status'] as String? ?? 'unknown';
    final type = _applicationData?['type'] as String? ?? 'N/A';
    final activity = _applicationData?['activity'] as String? ?? 'N/A';
    final legalStructure =
        _applicationData?['legalStructure'] as String? ?? 'N/A';
    final createdAt = _formatTimestamp(_applicationData?['createdAt']);
    final updatedAt = _formatTimestamp(_applicationData?['updatedAt']);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application $_applicationId',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Status', status.toUpperCase()),
            _buildInfoRow('Type', type),
            _buildInfoRow('Activity', activity),
            _buildInfoRow('Legal Structure', legalStructure),
            _buildInfoRow('Created', createdAt),
            _buildInfoRow('Updated', updatedAt),
            const SizedBox(height: 12),
            const Text(
              'Documents',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDocumentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    final documents = (_applicationData?['documents'] as List?)?.cast<String>() ??
        const <String>[];
    if (documents.isEmpty) {
      return const Text(
        'No documents uploaded.',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: documents
          .map(
            (doc) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.attachment, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(doc)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  String _formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toLocal().toString();
    }
    return 'N/A';
  }
}
