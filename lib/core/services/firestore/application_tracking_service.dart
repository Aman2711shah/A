import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Unified service to track all types of applications across the app
class ApplicationTrackingService {
  static ApplicationTrackingService? _instance;
  static ApplicationTrackingService get instance {
    _instance ??= ApplicationTrackingService._();
    return _instance!;
  }

  ApplicationTrackingService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get all applications for the current user across all types
  Future<List<Map<String, dynamic>>> getAllUserApplications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ No authenticated user');
        return [];
      }

      final allApplications = <Map<String, dynamic>>[];

      // Fetch trade license applications
      final tradeLicenses = await _firestore
          .collection('trade_license_applications')
          .where('userId', isEqualTo: userId)
          .orderBy('submittedAt', descending: true)
          .get();

      for (var doc in tradeLicenses.docs) {
        final data = doc.data();
        data['applicationType'] = 'Trade License';
        data['icon'] = '📄';
        _convertTimestamps(data);
        allApplications.add(data);
      }

      // Fetch visa applications
      final visas = await _firestore
          .collection('visa_applications')
          .where('userId', isEqualTo: userId)
          .orderBy('submittedAt', descending: true)
          .get();

      for (var doc in visas.docs) {
        final data = doc.data();
        data['applicationType'] = 'Visa';
        data['icon'] = '🛂';
        _convertTimestamps(data);
        allApplications.add(data);
      }

      // Fetch company setups
      final companies = await _firestore
          .collection('company_setups')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      for (var doc in companies.docs) {
        final data = doc.data();
        data['applicationType'] = 'Company Setup';
        data['icon'] = '🏢';
        // Company setups use updatedAt instead of submittedAt
        if (!data.containsKey('submittedAt') && data.containsKey('createdAt')) {
          data['submittedAt'] = data['createdAt'];
        }
        _convertTimestamps(data);
        allApplications.add(data);
      }

      // Sort all applications by submission date
      allApplications.sort((a, b) {
        final aDate = a['submittedAt'] as String? ?? '';
        final bDate = b['submittedAt'] as String? ?? '';
        return bDate.compareTo(aDate);
      });

      debugPrint('✅ Fetched ${allApplications.length} total applications');
      return allApplications;
    } catch (e) {
      debugPrint('❌ Error fetching all applications: $e');
      return [];
    }
  }

  /// Get applications filtered by status
  Future<List<Map<String, dynamic>>> getApplicationsByStatus(
      String status) async {
    final allApplications = await getAllUserApplications();
    return allApplications.where((app) => app['status'] == status).toList();
  }

  /// Get applications filtered by type
  Future<List<Map<String, dynamic>>> getApplicationsByType(String type) async {
    final allApplications = await getAllUserApplications();
    return allApplications
        .where((app) => app['applicationType'] == type)
        .toList();
  }

  /// Get application statistics
  Future<Map<String, dynamic>> getApplicationStats() async {
    try {
      final allApplications = await getAllUserApplications();

      final stats = {
        'total': allApplications.length,
        'submitted':
            allApplications.where((app) => app['status'] == 'Submitted').length,
        'inReview':
            allApplications.where((app) => app['status'] == 'In Review').length,
        'approved':
            allApplications.where((app) => app['status'] == 'Approved').length,
        'rejected':
            allApplications.where((app) => app['status'] == 'Rejected').length,
        'completed':
            allApplications.where((app) => app['status'] == 'Completed').length,
        'byType': {
          'tradeLicense': allApplications
              .where((app) => app['applicationType'] == 'Trade License')
              .length,
          'visa': allApplications
              .where((app) => app['applicationType'] == 'Visa')
              .length,
          'companySetup': allApplications
              .where((app) => app['applicationType'] == 'Company Setup')
              .length,
        },
      };

      return stats;
    } catch (e) {
      debugPrint('❌ Error calculating application stats: $e');
      return {
        'total': 0,
        'submitted': 0,
        'inReview': 0,
        'approved': 0,
        'rejected': 0,
        'completed': 0,
        'byType': {
          'tradeLicense': 0,
          'visa': 0,
          'companySetup': 0,
        },
      };
    }
  }

  /// Stream all applications for real-time updates
  Stream<List<Map<String, dynamic>>> streamAllApplications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    // Combine multiple streams using StreamGroup or manually
    // For simplicity, we'll poll periodically
    return Stream.periodic(const Duration(seconds: 5))
        .asyncMap((_) => getAllUserApplications());
  }

  /// Get recent applications (last 30 days)
  Future<List<Map<String, dynamic>>> getRecentApplications(
      {int days = 30}) async {
    final allApplications = await getAllUserApplications();
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    return allApplications.where((app) {
      final submittedAt = app['submittedAt'] as String?;
      if (submittedAt == null) return false;

      try {
        final date = DateTime.parse(submittedAt);
        return date.isAfter(cutoffDate);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Helper to convert Firestore Timestamps to ISO strings
  void _convertTimestamps(Map<String, dynamic> data) {
    if (data['submittedAt'] is Timestamp) {
      data['submittedAt'] =
          (data['submittedAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] =
          (data['updatedAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] =
          (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['completedAt'] is Timestamp) {
      data['completedAt'] =
          (data['completedAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['estimatedCompletion'] is Timestamp) {
      data['estimatedCompletion'] =
          (data['estimatedCompletion'] as Timestamp).toDate().toIso8601String();
    }
  }
}
