import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/services/firebase_firestore_service.dart';
import '../../../config/theme/app_colors.dart';

class TrackApplicationScreen extends StatefulWidget {
  static const String routeName = '/applications/track';

  const TrackApplicationScreen({super.key});

  @override
  State<TrackApplicationScreen> createState() => _TrackApplicationScreenState();
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
    final completedAt = _formatTimestamp(_applicationData?['completedAt']);

    // Enhanced fields
    final assignedAdvisor =
        _applicationData?['assignedAdvisor'] as Map<String, dynamic>?;
    final statusHistory = _applicationData?['statusHistory'] as List?;
    final estimatedCompletion =
        _applicationData?['estimatedCompletion'] as String?;
    final progressPercentage =
        _applicationData?['progressPercentage'] as int? ?? 0;
    final nextSteps = _applicationData?['nextSteps'] as String?;
    final remarks = _applicationData?['remarks'] as String?;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Status Banner
          _buildStatusBanner(status, progressPercentage),

          const SizedBox(height: 16),

          // Application Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.assignment, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Application $_applicationId',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Type', type),
                  _buildInfoRow('Activity', activity),
                  _buildInfoRow('Legal Structure', legalStructure),
                  _buildInfoRow('Created', createdAt),
                  _buildInfoRow('Last Updated', updatedAt),
                  if (completedAt != 'N/A')
                    _buildInfoRow('Completed', completedAt),
                  if (estimatedCompletion != null)
                    _buildInfoRow('Est. Completion', estimatedCompletion),
                ],
              ),
            ),
          ),

          // Assigned Advisor Card
          if (assignedAdvisor != null) _buildAdvisorCard(assignedAdvisor),

          // Progress Timeline
          if (statusHistory != null && statusHistory.isNotEmpty)
            _buildStatusTimeline(statusHistory),

          // Next Steps Card
          if (nextSteps != null) _buildNextStepsCard(nextSteps),

          // Remarks Card
          if (remarks != null) _buildRemarksCard(remarks),

          // Documents Card
          _buildDocumentsCard(),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(String status, int progressPercentage) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusText = 'Pending Review';
        break;
      case 'in_review':
        statusColor = Colors.blue;
        statusIcon = Icons.visibility;
        statusText = 'Under Review';
        break;
      case 'processing':
        statusColor = Colors.purple;
        statusIcon = Icons.sync;
        statusText = 'Processing';
        break;
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Approved';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.task_alt;
        statusText = 'Completed';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Rejected';
        break;
      case 'on_hold':
        statusColor = Colors.amber;
        statusIcon = Icons.pause_circle;
        statusText = 'On Hold';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusText = 'Unknown';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor, statusColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(statusIcon, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '$progressPercentage%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressPercentage / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisorCard(Map<String, dynamic> advisor) {
    final name = advisor['name'] as String? ?? 'Unassigned';
    final email = advisor['email'] as String?;
    final phone = advisor['phone'] as String?;
    final photo = advisor['photo'] as String?;

    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.support_agent, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Your Assigned Advisor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: photo != null ? NetworkImage(photo) : null,
                  child: photo == null
                      ? Text(
                          name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (email != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (phone != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(List statusHistory) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timeline, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Status History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...statusHistory.map((entry) {
              final status = entry['status'] as String? ?? 'Unknown';
              final timestamp = _formatTimestamp(entry['timestamp']);
              final note = entry['note'] as String?;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status.replaceAll('_', ' ').toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            timestamp,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (note != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              note,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepsCard(String nextSteps) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_forward, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Next Steps',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              nextSteps,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksCard(String remarks) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  'Remarks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              remarks,
              style: TextStyle(
                fontSize: 14,
                color: Colors.amber.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsCard() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_open, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Documents',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
    final documents = _applicationData?['documents'] as List?;

    if (documents == null || documents.isEmpty) {
      return const Text(
        'No documents uploaded.',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: documents.map<Widget>((doc) {
        // Handle both string (old format) and map (new format with URLs)
        String docName;
        String? docUrl;
        String? docType;

        if (doc is String) {
          docName = doc;
        } else if (doc is Map) {
          docName = doc['name'] as String? ?? 'Document';
          docUrl = doc['url'] as String?;
          docType = doc['type'] as String?;
        } else {
          docName = 'Unknown Document';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(
                _getDocumentIcon(docType ?? docName),
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      docName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (docType != null)
                      Text(
                        docType,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              if (docUrl != null)
                IconButton(
                  icon: const Icon(Icons.download, size: 20),
                  color: AppColors.primary,
                  onPressed: () => _downloadDocument(docUrl!, docName),
                  tooltip: 'Download',
                )
              else
                Icon(
                  Icons.pending,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getDocumentIcon(String docNameOrType) {
    final lower = docNameOrType.toLowerCase();
    if (lower.contains('passport')) return Icons.credit_card;
    if (lower.contains('photo')) return Icons.photo;
    if (lower.contains('noc')) return Icons.work;
    if (lower.contains('certificate') || lower.contains('degree')) {
      return Icons.school;
    }
    if (lower.contains('bank') || lower.contains('statement')) {
      return Icons.account_balance;
    }
    if (lower.contains('address') || lower.contains('proof')) return Icons.home;
    if (lower.contains('business') || lower.contains('plan')) {
      return Icons.business;
    }
    return Icons.description;
  }

  Future<void> _downloadDocument(String url, String fileName) async {
    try {
      // For web, open in new tab
      // ignore: avoid_web_libraries_in_flutter
      // html.window.open(url, '_blank');

      // For mobile, you would use url_launcher package
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening $fileName...'),
          action: SnackBarAction(
            label: 'Copy Link',
            onPressed: () {
              // Copy URL to clipboard
              // Clipboard.setData(ClipboardData(text: url));
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toLocal().toString();
    }
    return 'N/A';
  }
}
