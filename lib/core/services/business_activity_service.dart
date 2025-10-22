import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for managing business activities in Firestore
///
/// This service handles 4000+ business activities efficiently with:
/// - Search and filtering
/// - Category-based organization
/// - Caching for performance
/// - Multi-language support (ready)
class BusinessActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'business_activities';

  // Cache for frequently accessed data
  List<Map<String, dynamic>>? _cachedActivities;
  DateTime? _lastCacheUpdate;
  final Duration _cacheExpiry = const Duration(hours: 24);

  // Get all business activities (with optional caching)
  Future<List<Map<String, dynamic>>> getAllActivities({
    bool useCache = true,
  }) async {
    // Check cache
    if (useCache && _cachedActivities != null && _lastCacheUpdate != null) {
      final cacheAge = DateTime.now().difference(_lastCacheUpdate!);
      if (cacheAge < _cacheExpiry) {
        return _cachedActivities!;
      }
    }

    try {
      final snapshot =
          await _firestore.collection(_collection).orderBy('name').get();

      _cachedActivities = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      _lastCacheUpdate = DateTime.now();
      return _cachedActivities!;
    } catch (e) {
      rethrow;
    }
  }

  // Get activities by category
  Future<List<Map<String, dynamic>>> getActivitiesByCategory(
    String category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get activities by license type
  Future<List<Map<String, dynamic>>> getActivitiesByLicenseType(
    String licenseType, // 'commercial', 'professional', 'industrial', 'tourism'
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('licenseType', isEqualTo: licenseType)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Search activities by name or code
  Future<List<Map<String, dynamic>>> searchActivities(String query) async {
    if (query.isEmpty) return [];

    try {
      final lowercaseQuery = query.toLowerCase();

      // Get all activities (from cache if available)
      final allActivities = await getAllActivities();

      // Filter locally for better search
      return allActivities.where((activity) {
        final name = (activity['name'] as String).toLowerCase();
        final code = (activity['code'] as String?)?.toLowerCase() ?? '';
        final nameAr = (activity['nameAr'] as String?)?.toLowerCase() ?? '';

        return name.contains(lowercaseQuery) ||
            code.contains(lowercaseQuery) ||
            nameAr.contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get popular/most used activities
  Stream<QuerySnapshot> getPopularActivities({int limit = 50}) {
    return _firestore
        .collection(_collection)
        .where('isPopular', isEqualTo: true)
        .orderBy('usageCount', descending: true)
        .limit(limit)
        .snapshots();
  }

  // Get activities by freezone compatibility
  Future<List<Map<String, dynamic>>> getActivitiesByFreezone(
    String freezoneName,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('compatibleFreezones', arrayContains: freezoneName)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get activity by ID
  Future<Map<String, dynamic>?> getActivityById(String activityId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(activityId).get();

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Track activity usage (for analytics)
  Future<void> incrementActivityUsage(String activityId) async {
    try {
      await _firestore.collection(_collection).doc(activityId).update({
        'usageCount': FieldValue.increment(1),
        'lastUsed': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silent fail for analytics
    }
  }

  // Clear cache
  void clearCache() {
    _cachedActivities = null;
    _lastCacheUpdate = null;
  }

  // Get categories list
  Future<List<String>> getCategories() async {
    try {
      final snapshot =
          await _firestore.collection(_collection).orderBy('category').get();

      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final category = doc.data()['category'] as String?;
        if (category != null) {
          categories.add(category);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      rethrow;
    }
  }

  // Batch upload activities (for initial setup)
  Future<void> batchUploadActivities(
    List<Map<String, dynamic>> activities,
  ) async {
    try {
      final batch = _firestore.batch();
      int count = 0;

      for (var activity in activities) {
        final docRef = _firestore.collection(_collection).doc();
        batch.set(docRef, {
          ...activity,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'usageCount': 0,
          'isPopular': false,
        });

        count++;

        // Firestore batch limit is 500
        if (count % 500 == 0) {
          await batch.commit();
          // Create new batch
        }
      }

      // Commit remaining
      if (count % 500 != 0) {
        await batch.commit();
      }

      // Clear cache after upload
      clearCache();
    } catch (e) {
      rethrow;
    }
  }
}
