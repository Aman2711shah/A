import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class TradeLicenseDataSource {
  Future<String> submitApplication(Map<String, dynamic> applicationData);
  Future<List<Map<String, dynamic>>> getUserApplications();
  Future<Map<String, dynamic>?> getApplicationById(String applicationId);
  Future<void> updateApplicationStatus(String applicationId, String newStatus);
  Future<void> updateApplication(
      String applicationId, Map<String, dynamic> updates);
  Future<void> deleteApplication(String applicationId);
  Stream<List<Map<String, dynamic>>> streamUserApplications();
}

class TradeLicenseFirestoreService implements TradeLicenseDataSource {
  static TradeLicenseFirestoreService? _instance;
  static TradeLicenseFirestoreService get instance {
    _instance ??= TradeLicenseFirestoreService._();
    return _instance!;
  }

  TradeLicenseFirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collectionName = 'trade_license_applications';

  /// Submit a new trade license application
  @override
  Future<String> submitApplication(Map<String, dynamic> applicationData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated to submit application');
      }

      final docRef = _firestore.collection(_collectionName).doc();

      final data = {
        ...applicationData,
        'id': docRef.id,
        'userId': userId,
        'status': 'Submitted',
        'submittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'estimatedCompletionDays': 7,
      };

      await docRef.set(data);
      debugPrint('✅ Trade license application submitted: ${docRef.id}');

      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error submitting trade license application: $e');
      rethrow;
    }
  }

  /// Get all applications for the current user
  @override
  Future<List<Map<String, dynamic>>> getUserApplications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ No authenticated user, returning empty list');
        return [];
      }

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('submittedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Convert Timestamp to String for UI compatibility
        if (data['submittedAt'] is Timestamp) {
          data['submittedAt'] =
              (data['submittedAt'] as Timestamp).toDate().toIso8601String();
        }
        if (data['updatedAt'] is Timestamp) {
          data['updatedAt'] =
              (data['updatedAt'] as Timestamp).toDate().toIso8601String();
        }
        // Calculate estimated completion
        if (data['submittedAt'] is String &&
            data['estimatedCompletionDays'] != null) {
          final submittedDate = DateTime.parse(data['submittedAt'] as String);
          final completionDate = submittedDate
              .add(Duration(days: data['estimatedCompletionDays'] as int));
          data['estimatedCompletion'] = completionDate.toIso8601String();
        }
        return data;
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching user applications: $e');
      return [];
    }
  }

  /// Get a specific application by ID
  @override
  Future<Map<String, dynamic>?> getApplicationById(String applicationId) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(applicationId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      // Convert Timestamp to String
      if (data['submittedAt'] is Timestamp) {
        data['submittedAt'] =
            (data['submittedAt'] as Timestamp).toDate().toIso8601String();
      }
      if (data['updatedAt'] is Timestamp) {
        data['updatedAt'] =
            (data['updatedAt'] as Timestamp).toDate().toIso8601String();
      }

      return data;
    } catch (e) {
      debugPrint('❌ Error fetching application by ID: $e');
      return null;
    }
  }

  /// Update application status
  @override
  Future<void> updateApplicationStatus(
      String applicationId, String newStatus) async {
    try {
      await _firestore.collection(_collectionName).doc(applicationId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Application $applicationId status updated to: $newStatus');
    } catch (e) {
      debugPrint('❌ Error updating application status: $e');
      rethrow;
    }
  }

  /// Update application data
  @override
  Future<void> updateApplication(
      String applicationId, Map<String, dynamic> updates) async {
    try {
      final data = {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_collectionName)
          .doc(applicationId)
          .update(data);
      debugPrint('✅ Application $applicationId updated');
    } catch (e) {
      debugPrint('❌ Error updating application: $e');
      rethrow;
    }
  }

  /// Delete an application
  @override
  Future<void> deleteApplication(String applicationId) async {
    try {
      await _firestore.collection(_collectionName).doc(applicationId).delete();
      debugPrint('✅ Application $applicationId deleted');
    } catch (e) {
      debugPrint('❌ Error deleting application: $e');
      rethrow;
    }
  }

  /// Get applications by status
  Future<List<Map<String, dynamic>>> getApplicationsByStatus(
      String status) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return [];
      }

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('submittedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        if (data['submittedAt'] is Timestamp) {
          data['submittedAt'] =
              (data['submittedAt'] as Timestamp).toDate().toIso8601String();
        }
        return data;
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching applications by status: $e');
      return [];
    }
  }

  /// Stream of user's applications for real-time updates
  @override
  Stream<List<Map<String, dynamic>>> streamUserApplications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        if (data['submittedAt'] is Timestamp) {
          data['submittedAt'] =
              (data['submittedAt'] as Timestamp).toDate().toIso8601String();
        }
        if (data['updatedAt'] is Timestamp) {
          data['updatedAt'] =
              (data['updatedAt'] as Timestamp).toDate().toIso8601String();
        }
        return data;
      }).toList();
    });
  }
}
