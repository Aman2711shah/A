import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProfileFirestoreService {
  static UserProfileFirestoreService? _instance;
  static UserProfileFirestoreService get instance {
    _instance ??= UserProfileFirestoreService._();
    return _instance!;
  }

  UserProfileFirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collectionName = 'user_profiles';

  /// Create or update user profile
  Future<void> saveProfile(Map<String, dynamic> profileData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated to save profile');
      }

      final docRef = _firestore.collection(_collectionName).doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing profile
        await docRef.update({
          ...profileData,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('✅ User profile updated: $userId');
      } else {
        // Create new profile
        final data = {
          ...profileData,
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
        await docRef.set(data);
        debugPrint('✅ User profile created: $userId');
      }
    } catch (e) {
      debugPrint('❌ Error saving user profile: $e');
      rethrow;
    }
  }

  /// Get the current user's profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ No authenticated user');
        return null;
      }

      final docSnapshot =
          await _firestore.collection(_collectionName).doc(userId).get();

      if (!docSnapshot.exists) {
        debugPrint('⚠️ No profile found for user: $userId');
        return null;
      }

      final data = docSnapshot.data()!;
      _convertTimestamps(data);

      return data;
    } catch (e) {
      debugPrint('❌ Error fetching user profile: $e');
      return null;
    }
  }

  /// Get a specific user's profile by user ID (for admin purposes)
  Future<Map<String, dynamic>?> getProfileById(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(userId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      _convertTimestamps(data);

      return data;
    } catch (e) {
      debugPrint('❌ Error fetching profile by ID: $e');
      return null;
    }
  }

  /// Update specific profile fields
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated to update profile');
      }

      final data = {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(_collectionName).doc(userId).update(data);
      debugPrint('✅ User profile updated: $userId');
    } catch (e) {
      debugPrint('❌ Error updating user profile: $e');
      rethrow;
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated');
      }

      await _firestore.collection(_collectionName).doc(userId).update({
        'preferences': preferences,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ User preferences updated');
    } catch (e) {
      debugPrint('❌ Error updating preferences: $e');
      rethrow;
    }
  }

  /// Add to user's activity history
  Future<void> addActivityLog(
      String activity, Map<String, dynamic>? metadata) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return;
      }

      final activityLog = {
        'activity': activity,
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': metadata ?? {},
      };

      await _firestore.collection(_collectionName).doc(userId).update({
        'activityHistory': FieldValue.arrayUnion([activityLog]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Activity logged: $activity');
    } catch (e) {
      debugPrint('❌ Error logging activity: $e');
      // Don't rethrow - activity logging shouldn't break the app
    }
  }

  /// Update user's notification settings
  Future<void> updateNotificationSettings(Map<String, bool> settings) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated');
      }

      await _firestore.collection(_collectionName).doc(userId).update({
        'notificationSettings': settings,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Notification settings updated');
    } catch (e) {
      debugPrint('❌ Error updating notification settings: $e');
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated');
      }

      await _firestore.collection(_collectionName).doc(userId).delete();
      debugPrint('✅ User profile deleted: $userId');
    } catch (e) {
      debugPrint('❌ Error deleting user profile: $e');
      rethrow;
    }
  }

  /// Stream user profile for real-time updates
  Stream<Map<String, dynamic>?> streamProfile() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection(_collectionName)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data()!;
      _convertTimestamps(data);
      return data;
    });
  }

  /// Check if profile exists
  Future<bool> profileExists() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return false;
      }

      final docSnapshot =
          await _firestore.collection(_collectionName).doc(userId).get();

      return docSnapshot.exists;
    } catch (e) {
      debugPrint('❌ Error checking profile existence: $e');
      return false;
    }
  }

  /// Initialize default profile for new users
  Future<void> initializeDefaultProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      final userEmail = _auth.currentUser?.email;

      if (userId == null) {
        throw Exception('User must be authenticated');
      }

      final exists = await profileExists();
      if (exists) {
        debugPrint('⚠️ Profile already exists for user: $userId');
        return;
      }

      final defaultProfile = {
        'userId': userId,
        'email': userEmail,
        'displayName': _auth.currentUser?.displayName ?? '',
        'photoURL': _auth.currentUser?.photoURL ?? '',
        'preferences': {
          'language': 'en',
          'currency': 'AED',
          'notifications': true,
        },
        'notificationSettings': {
          'email': true,
          'push': true,
          'sms': false,
        },
        'activityHistory': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .set(defaultProfile);

      debugPrint('✅ Default profile initialized for user: $userId');
    } catch (e) {
      debugPrint('❌ Error initializing default profile: $e');
      rethrow;
    }
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
  }
}
