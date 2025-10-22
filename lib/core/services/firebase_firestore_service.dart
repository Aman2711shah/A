import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== COMPANIES ====================

  // Create company
  Future<String> createCompany(Map<String, dynamic> companyData) async {
    try {
      companyData['createdAt'] = FieldValue.serverTimestamp();
      companyData['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection('companies').add(companyData);
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get company by ID
  Future<DocumentSnapshot> getCompany(String companyId) async {
    return await _firestore.collection('companies').doc(companyId).get();
  }

  // Get user companies
  Stream<QuerySnapshot> getUserCompanies(String userId) {
    return _firestore
        .collection('companies')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update company
  Future<void> updateCompany(
      String companyId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('companies').doc(companyId).update(data);
  }

  // Delete company
  Future<void> deleteCompany(String companyId) async {
    await _firestore.collection('companies').doc(companyId).delete();
  }

  // ==================== APPLICATIONS ====================

  // Create application
  Future<String> createApplication(Map<String, dynamic> applicationData) async {
    try {
      applicationData['createdAt'] = FieldValue.serverTimestamp();
      applicationData['updatedAt'] = FieldValue.serverTimestamp();
      applicationData['status'] = 'pending';

      final docRef =
          await _firestore.collection('applications').add(applicationData);
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get application by ID
  Future<DocumentSnapshot> getApplication(String applicationId) async {
    return await _firestore.collection('applications').doc(applicationId).get();
  }

  // Get user applications
  Stream<QuerySnapshot> getUserApplications(String userId) {
    return _firestore
        .collection('applications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update application status
  Future<void> updateApplicationStatus(
      String applicationId, String status) async {
    await _firestore.collection('applications').doc(applicationId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      if (status == 'completed') 'completedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update application
  Future<void> updateApplication(
      String applicationId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('applications').doc(applicationId).update(data);
  }

  // Delete application
  Future<void> deleteApplication(String applicationId) async {
    await _firestore.collection('applications').doc(applicationId).delete();
  }

  // ==================== SERVICES ====================

  // Get all services
  Stream<QuerySnapshot> getAllServices() {
    return _firestore
        .collection('services')
        .where('active', isEqualTo: true)
        .snapshots();
  }

  // Get services by category
  Stream<QuerySnapshot> getServicesByCategory(String category) {
    return _firestore
        .collection('services')
        .where('category', isEqualTo: category)
        .where('active', isEqualTo: true)
        .snapshots();
  }

  // Get service by ID
  Future<DocumentSnapshot> getService(String serviceId) async {
    return await _firestore.collection('services').doc(serviceId).get();
  }

  // ==================== DOCUMENTS ====================

  // Upload document metadata
  Future<String> uploadDocumentMetadata(
      Map<String, dynamic> documentData) async {
    try {
      documentData['createdAt'] = FieldValue.serverTimestamp();
      documentData['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection('documents').add(documentData);
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get user documents
  Stream<QuerySnapshot> getUserDocuments(String userId) {
    return _firestore
        .collection('documents')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Delete document metadata
  Future<void> deleteDocumentMetadata(String documentId) async {
    await _firestore.collection('documents').doc(documentId).delete();
  }

  // ==================== CONSULTATION REQUESTS ====================

  Future<String> createConsultationRequest(
      Map<String, dynamic> consultationData) async {
    try {
      consultationData['createdAt'] = FieldValue.serverTimestamp();
      consultationData['status'] = consultationData['status'] ?? 'pending';

      final docRef = await _firestore
          .collection('consultation_requests')
          .add(consultationData);
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== COMMUNITY ====================

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToCommunityPosts() {
    return _firestore
        .collection('community_posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<String> createCommunityPost(Map<String, dynamic> postData) async {
    try {
      postData['createdAt'] = FieldValue.serverTimestamp();
      postData['likes'] = postData['likes'] ?? <String>[];
      postData['commentCount'] = 0;
      final doc =
          await _firestore.collection('community_posts').add(postData);
      return doc.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleCommunityPostLike({
    required String postId,
    required String userId,
    required bool like,
  }) async {
    final docRef = _firestore.collection('community_posts').doc(postId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;
      final likes = List<String>.from(snapshot.get('likes') as List? ?? []);
      if (like) {
        if (!likes.contains(userId)) {
          likes.add(userId);
        }
      } else {
        likes.remove(userId);
      }
      transaction.update(docRef, {'likes': likes});
    });
  }

  Future<void> addCommunityComment({
    required String postId,
    required Map<String, dynamic> commentData,
  }) async {
    final commentsRef = _firestore
        .collection('community_posts')
        .doc(postId)
        .collection('comments');

    await _firestore.runTransaction((transaction) async {
      final postRef = _firestore.collection('community_posts').doc(postId);
      final postSnapshot = await transaction.get(postRef);
      if (!postSnapshot.exists) {
        throw StateError('Post no longer exists');
      }

      transaction.update(postRef, {
        'commentCount': FieldValue.increment(1),
      });

      transaction.set(
        commentsRef.doc(),
        {
          ...commentData,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToComments(String postId) {
    return _firestore
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ==================== NOTIFICATIONS ====================

  // Create notification
  Future<String> createNotification(
      Map<String, dynamic> notificationData) async {
    try {
      notificationData['createdAt'] = FieldValue.serverTimestamp();
      notificationData['read'] = false;

      final docRef =
          await _firestore.collection('notifications').add(notificationData);
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get user notifications
  Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'read': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead(String userId) async {
    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {
        'read': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  // ==================== ANALYTICS ====================

  // Log activity
  Future<void> logActivity(Map<String, dynamic> activityData) async {
    try {
      activityData['timestamp'] = FieldValue.serverTimestamp();
      await _firestore.collection('activities').add(activityData);
    } catch (e) {
      // Silent fail for analytics
    }
  }

  // ==================== BATCH OPERATIONS ====================

  // Batch write
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    final batch = _firestore.batch();

    for (var operation in operations) {
      final collection = operation['collection'] as String;
      final docId = operation['docId'] as String?;
      final data = operation['data'] as Map<String, dynamic>;
      final type = operation['type'] as String; // 'set', 'update', 'delete'

      final ref = docId != null
          ? _firestore.collection(collection).doc(docId)
          : _firestore.collection(collection).doc();

      switch (type) {
        case 'set':
          batch.set(ref, data);
          break;
        case 'update':
          batch.update(ref, data);
          break;
        case 'delete':
          batch.delete(ref);
          break;
      }
    }

    await batch.commit();
  }
}
