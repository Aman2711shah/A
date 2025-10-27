import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service to manage admin operations and dashboard data
class AdminService {
  static AdminService? _instance;
  static AdminService get instance {
    _instance ??= AdminService._();
    return _instance!;
  }

  AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Check if current user is admin
  Future<bool> isAdmin() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final userDoc = await _firestore.collection('admins').doc(userId).get();
      return userDoc.exists && (userDoc.data()?['isActive'] ?? false);
    } catch (e) {
      debugPrint('❌ Error checking admin status: $e');
      return false;
    }
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Get all applications counts
      final tradeLicenseCount =
          await _getCollectionCount('trade_license_applications');
      final visaCount = await _getCollectionCount('visa_applications');
      final companySetupCount = await _getCollectionCount('company_setups');
      final userCount = await _getCollectionCount('user_profiles');

      // Get today's submissions
      final todaySubmissions = await _getTodaySubmissions();

      // Get monthly revenue (if pricing data is stored)
      final monthlyRevenue = await _getMonthlyRevenue(startOfMonth);

      // Get status breakdown
      final statusBreakdown = await _getStatusBreakdown();

      // Get popular freezones
      final popularFreezones = await _getPopularFreezones();

      return {
        'totalApplications': tradeLicenseCount + visaCount + companySetupCount,
        'tradeLicenseCount': tradeLicenseCount,
        'visaCount': visaCount,
        'companySetupCount': companySetupCount,
        'totalUsers': userCount,
        'todaySubmissions': todaySubmissions,
        'monthlyRevenue': monthlyRevenue,
        'statusBreakdown': statusBreakdown,
        'popularFreezones': popularFreezones,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error getting dashboard stats: $e');
      return {};
    }
  }

  /// Get count of documents in a collection
  Future<int> _getCollectionCount(String collection) async {
    try {
      final snapshot = await _firestore.collection(collection).count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Error counting $collection: $e');
      return 0;
    }
  }

  /// Get today's submissions count
  Future<int> _getTodaySubmissions() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final timestamp = Timestamp.fromDate(startOfDay);

      int count = 0;

      // Trade licenses submitted today
      final tradeLicenses = await _firestore
          .collection('trade_license_applications')
          .where('submittedAt', isGreaterThanOrEqualTo: timestamp)
          .count()
          .get();
      count += tradeLicenses.count ?? 0;

      // Visas submitted today
      final visas = await _firestore
          .collection('visa_applications')
          .where('submittedAt', isGreaterThanOrEqualTo: timestamp)
          .count()
          .get();
      count += visas.count ?? 0;

      return count;
    } catch (e) {
      debugPrint('❌ Error getting today submissions: $e');
      return 0;
    }
  }

  /// Get monthly revenue
  Future<double> _getMonthlyRevenue(DateTime monthStart) async {
    try {
      final timestamp = Timestamp.fromDate(monthStart);
      double revenue = 0;

      // Get trade license applications with pricing
      final tradeLicenses = await _firestore
          .collection('trade_license_applications')
          .where('submittedAt', isGreaterThanOrEqualTo: timestamp)
          .where('status', whereIn: ['Approved', 'Completed']).get();

      for (var doc in tradeLicenses.docs) {
        final price = doc.data()['priceAED'] as num?;
        if (price != null) revenue += price.toDouble();
      }

      return revenue;
    } catch (e) {
      debugPrint('❌ Error calculating monthly revenue: $e');
      return 0;
    }
  }

  /// Get status breakdown across all applications
  Future<Map<String, int>> _getStatusBreakdown() async {
    try {
      final breakdown = <String, int>{};

      // Trade licenses
      final tradeLicenses =
          await _firestore.collection('trade_license_applications').get();

      for (var doc in tradeLicenses.docs) {
        final status = doc.data()['status'] as String? ?? 'Unknown';
        breakdown[status] = (breakdown[status] ?? 0) + 1;
      }

      // Visas
      final visas = await _firestore.collection('visa_applications').get();

      for (var doc in visas.docs) {
        final status = doc.data()['status'] as String? ?? 'Unknown';
        breakdown[status] = (breakdown[status] ?? 0) + 1;
      }

      return breakdown;
    } catch (e) {
      debugPrint('❌ Error getting status breakdown: $e');
      return {};
    }
  }

  /// Get popular freezones
  Future<List<Map<String, dynamic>>> _getPopularFreezones() async {
    try {
      final freezoneCount = <String, int>{};

      final tradeLicenses =
          await _firestore.collection('trade_license_applications').get();

      for (var doc in tradeLicenses.docs) {
        final freezone = doc.data()['freezoneName'] as String? ?? 'Unknown';
        freezoneCount[freezone] = (freezoneCount[freezone] ?? 0) + 1;
      }

      // Convert to sorted list
      final sorted = freezoneCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sorted
          .take(10)
          .map((e) => {
                'name': e.key,
                'count': e.value,
              })
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting popular freezones: $e');
      return [];
    }
  }

  /// Get all applications with filters
  Future<List<Map<String, dynamic>>> getAllApplications({
    String? status,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final applications = <Map<String, dynamic>>[];

      // Query trade licenses
      if (type == null || type == 'Trade License') {
        var query = _firestore
            .collection('trade_license_applications')
            .orderBy('submittedAt', descending: true);

        if (status != null) {
          query = query.where('status', isEqualTo: status);
        }
        if (startDate != null) {
          query = query.where('submittedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
        }
        if (endDate != null) {
          query = query.where('submittedAt',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate));
        }

        final snapshot = await query.limit(limit).get();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          data['applicationType'] = 'Trade License';
          data['icon'] = '📄';
          _convertTimestamps(data);
          applications.add(data);
        }
      }

      // Query visas
      if (type == null || type == 'Visa') {
        var query = _firestore
            .collection('visa_applications')
            .orderBy('submittedAt', descending: true);

        if (status != null) {
          query = query.where('status', isEqualTo: status);
        }
        if (startDate != null) {
          query = query.where('submittedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
        }
        if (endDate != null) {
          query = query.where('submittedAt',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate));
        }

        final snapshot = await query.limit(limit).get();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          data['applicationType'] = 'Visa';
          data['icon'] = '🛂';
          _convertTimestamps(data);
          applications.add(data);
        }
      }

      // Sort by date
      applications.sort((a, b) {
        final aDate = a['submittedAt'] as String? ?? '';
        final bDate = b['submittedAt'] as String? ?? '';
        return bDate.compareTo(aDate);
      });

      return applications.take(limit).toList();
    } catch (e) {
      debugPrint('❌ Error getting all applications: $e');
      return [];
    }
  }

  /// Update application status (admin only)
  Future<void> updateApplicationStatus({
    required String applicationId,
    required String applicationType,
    required String newStatus,
    String? remarks,
  }) async {
    try {
      final collection = applicationType == 'Trade License'
          ? 'trade_license_applications'
          : 'visa_applications';

      final updates = {
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (remarks != null) {
        updates['adminRemarks'] = remarks;
      }

      await _firestore
          .collection(collection)
          .doc(applicationId)
          .update(updates);

      debugPrint('✅ Application $applicationId status updated to: $newStatus');

      // TODO: Trigger push notification to user
    } catch (e) {
      debugPrint('❌ Error updating application status: $e');
      rethrow;
    }
  }

  /// Get all users
  Future<List<Map<String, dynamic>>> getAllUsers({
    int limit = 50,
    String? searchQuery,
  }) async {
    try {
      Query query = _firestore
          .collection('user_profiles')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      final snapshot = await query.get();

      final users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        _convertTimestamps(data);
        return data;
      }).toList();

      // Filter by search query if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return users.where((user) {
          final email = (user['email'] as String?)?.toLowerCase() ?? '';
          final name = (user['displayName'] as String?)?.toLowerCase() ?? '';
          return email.contains(query) || name.contains(query);
        }).toList();
      }

      return users;
    } catch (e) {
      debugPrint('❌ Error getting users: $e');
      return [];
    }
  }

  /// Get user applications
  Future<List<Map<String, dynamic>>> getUserApplications(String userId) async {
    try {
      final applications = <Map<String, dynamic>>[];

      // Trade licenses
      final tradeLicenses = await _firestore
          .collection('trade_license_applications')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in tradeLicenses.docs) {
        final data = doc.data();
        data['applicationType'] = 'Trade License';
        _convertTimestamps(data);
        applications.add(data);
      }

      // Visas
      final visas = await _firestore
          .collection('visa_applications')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in visas.docs) {
        final data = doc.data();
        data['applicationType'] = 'Visa';
        _convertTimestamps(data);
        applications.add(data);
      }

      return applications;
    } catch (e) {
      debugPrint('❌ Error getting user applications: $e');
      return [];
    }
  }

  /// Add admin user
  Future<void> addAdmin(String userId, {String? email, String? name}) async {
    try {
      await _firestore.collection('admins').doc(userId).set({
        'userId': userId,
        'email': email,
        'name': name,
        'isActive': true,
        'role': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': _auth.currentUser?.uid,
      });

      debugPrint('✅ Admin added: $userId');
    } catch (e) {
      debugPrint('❌ Error adding admin: $e');
      rethrow;
    }
  }

  /// Remove admin
  Future<void> removeAdmin(String userId) async {
    try {
      await _firestore.collection('admins').doc(userId).update({
        'isActive': false,
        'deactivatedAt': FieldValue.serverTimestamp(),
        'deactivatedBy': _auth.currentUser?.uid,
      });

      debugPrint('✅ Admin removed: $userId');
    } catch (e) {
      debugPrint('❌ Error removing admin: $e');
      rethrow;
    }
  }

  /// Helper to convert Firestore timestamps
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
  }
}
