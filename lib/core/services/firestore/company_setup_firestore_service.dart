import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CompanySetupFirestoreService {
  static CompanySetupFirestoreService? _instance;
  static CompanySetupFirestoreService get instance {
    _instance ??= CompanySetupFirestoreService._();
    return _instance!;
  }

  CompanySetupFirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collectionName = 'company_setups';

  /// Create or update a company setup
  Future<String> saveCompanySetup(Map<String, dynamic> setupData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated to save company setup');
      }

      // Check if user already has a setup in progress
      final existing = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'In Progress')
          .limit(1)
          .get();

      DocumentReference docRef;

      if (existing.docs.isNotEmpty) {
        // Update existing setup
        docRef = existing.docs.first.reference;
        await docRef.update({
          ...setupData,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('✅ Company setup updated: ${docRef.id}');
      } else {
        // Create new setup
        docRef = _firestore.collection(_collectionName).doc();
        final data = {
          ...setupData,
          'id': docRef.id,
          'userId': userId,
          'status': 'In Progress',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'currentStep': 0,
          'completedSteps': [],
        };
        await docRef.set(data);
        debugPrint('✅ Company setup created: ${docRef.id}');
      }

      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error saving company setup: $e');
      rethrow;
    }
  }

  /// Get the user's current company setup (in progress or latest completed)
  Future<Map<String, dynamic>?> getCurrentSetup() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ No authenticated user');
        return null;
      }

      // First, try to find an in-progress setup
      var querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'In Progress')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no in-progress setup, get the latest one
        querySnapshot = await _firestore
            .collection(_collectionName)
            .where('userId', isEqualTo: userId)
            .orderBy('updatedAt', descending: true)
            .limit(1)
            .get();
      }

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final data = querySnapshot.docs.first.data();
      _convertTimestamps(data);

      return data;
    } catch (e) {
      debugPrint('❌ Error fetching current setup: $e');
      return null;
    }
  }

  /// Get a specific company setup by ID
  Future<Map<String, dynamic>?> getSetupById(String setupId) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(setupId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      _convertTimestamps(data);

      return data;
    } catch (e) {
      debugPrint('❌ Error fetching setup by ID: $e');
      return null;
    }
  }

  /// Update the current step in the setup wizard
  Future<void> updateCurrentStep(String setupId, int stepNumber) async {
    try {
      await _firestore.collection(_collectionName).doc(setupId).update({
        'currentStep': stepNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Setup $setupId step updated to: $stepNumber');
    } catch (e) {
      debugPrint('❌ Error updating setup step: $e');
      rethrow;
    }
  }

  /// Mark a step as completed
  Future<void> markStepCompleted(String setupId, int stepNumber) async {
    try {
      await _firestore.collection(_collectionName).doc(setupId).update({
        'completedSteps': FieldValue.arrayUnion([stepNumber]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Setup $setupId step $stepNumber marked completed');
    } catch (e) {
      debugPrint('❌ Error marking step completed: $e');
      rethrow;
    }
  }

  /// Complete the company setup
  Future<void> completeSetup(String setupId) async {
    try {
      await _firestore.collection(_collectionName).doc(setupId).update({
        'status': 'Completed',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Company setup $setupId completed');
    } catch (e) {
      debugPrint('❌ Error completing setup: $e');
      rethrow;
    }
  }

  /// Update company setup data
  Future<void> updateSetup(String setupId, Map<String, dynamic> updates) async {
    try {
      final data = {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(_collectionName).doc(setupId).update(data);
      debugPrint('✅ Company setup $setupId updated');
    } catch (e) {
      debugPrint('❌ Error updating company setup: $e');
      rethrow;
    }
  }

  /// Delete a company setup
  Future<void> deleteSetup(String setupId) async {
    try {
      await _firestore.collection(_collectionName).doc(setupId).delete();
      debugPrint('✅ Company setup $setupId deleted');
    } catch (e) {
      debugPrint('❌ Error deleting company setup: $e');
      rethrow;
    }
  }

  /// Get all company setups for the user
  Future<List<Map<String, dynamic>>> getUserSetups() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ No authenticated user');
        return [];
      }

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        _convertTimestamps(data);
        return data;
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching user setups: $e');
      return [];
    }
  }

  /// Stream of user's current setup for real-time updates
  Stream<Map<String, dynamic>?> streamCurrentSetup() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'In Progress')
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      final data = snapshot.docs.first.data();
      _convertTimestamps(data);
      return data;
    });
  }

  /// Helper to convert Firestore Timestamps to ISO strings
  void _convertTimestamps(Map<String, dynamic> data) {
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] =
          (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] =
          (data['updatedAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['completedAt'] is Timestamp) {
      data['completedAt'] =
          (data['completedAt'] as Timestamp).toDate().toIso8601String();
    }
  }
}
