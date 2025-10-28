import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class VisaDataSource {
  Future<String> submitApplication(Map<String, dynamic> applicationData);
  Future<List<Map<String, dynamic>>> getUserApplications();
  Future<Map<String, dynamic>?> getApplicationById(String applicationId);
  Future<void> updateApplicationStatus(String applicationId, String newStatus);
  Future<void> updateApplication(
      String applicationId, Map<String, dynamic> updates);
  Future<void> deleteApplication(String applicationId);
  Stream<List<Map<String, dynamic>>> streamUserApplications();
  Future<List<Map<String, dynamic>>> getApplicationsByStatus(String status);
  Future<List<Map<String, dynamic>>> getApplicationsByVisaType(String visaType);
}

class VisaFirestoreService implements VisaDataSource {
  static VisaFirestoreService? _instance;
  static VisaFirestoreService get instance {
    _instance ??= VisaFirestoreService._();
    return _instance!;
  }

  VisaFirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collectionName = 'visa_applications';

  /// Submit a new visa application
  @override
  Future<String> submitApplication(Map<String, dynamic> applicationData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception(
            'User must be authenticated to submit visa application');
      }

      final docRef = _firestore.collection(_collectionName).doc();

      final data = {
        ...applicationData,
        'id': docRef.id,
        'userId': userId,
        'status': 'Submitted',
        'submittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'estimatedProcessingDays': 14,
      };

      await docRef.set(data);
      debugPrint('✅ Visa application submitted: ${docRef.id}');

      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error submitting visa application: $e');
      rethrow;
    }
  }

  /// Get all visa applications for the current user
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
        if (data['submittedAt'] is Timestamp) {
          data['submittedAt'] =
              (data['submittedAt'] as Timestamp).toDate().toIso8601String();
        }
        if (data['updatedAt'] is Timestamp) {
          data['updatedAt'] =
              (data['updatedAt'] as Timestamp).toDate().toIso8601String();
        }
        if (data['submittedAt'] is String &&
            data['estimatedProcessingDays'] != null) {
          final submittedDate = DateTime.parse(data['submittedAt'] as String);
          final completionDate = submittedDate
              .add(Duration(days: data['estimatedProcessingDays'] as int));
          data['estimatedCompletion'] = completionDate.toIso8601String();
        }
        return data;
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching visa applications: $e');
      return [];
    }
  }

  /// Get a specific visa application by ID
  @override
  Future<Map<String, dynamic>?> getApplicationById(String applicationId) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(applicationId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
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
      debugPrint('❌ Error fetching visa application by ID: $e');
      return null;
    }
  }

  /// Update visa application status
  @override
  Future<void> updateApplicationStatus(
      String applicationId, String newStatus) async {
    try {
      await _firestore.collection(_collectionName).doc(applicationId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint(
          '✅ Visa application $applicationId status updated to: $newStatus');
    } catch (e) {
      debugPrint('❌ Error updating visa application status: $e');
      rethrow;
    }
  }

  /// Update visa application data
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
      debugPrint('✅ Visa application $applicationId updated');
    } catch (e) {
      debugPrint('❌ Error updating visa application: $e');
      rethrow;
    }
  }

  /// Delete a visa application
  @override
  Future<void> deleteApplication(String applicationId) async {
    try {
      await _firestore.collection(_collectionName).doc(applicationId).delete();
      debugPrint('✅ Visa application $applicationId deleted');
    } catch (e) {
      debugPrint('❌ Error deleting visa application: $e');
      rethrow;
    }
  }

  /// Get visa applications by status
  @override
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
      debugPrint('❌ Error fetching visa applications by status: $e');
      return [];
    }
  }

  /// Stream of user's visa applications for real-time updates
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

  /// Get visa applications by visa type
  @override
  Future<List<Map<String, dynamic>>> getApplicationsByVisaType(
      String visaType) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return [];
      }

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('visaType', isEqualTo: visaType)
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
      debugPrint('❌ Error fetching visa applications by type: $e');
      return [];
    }
  }
}
