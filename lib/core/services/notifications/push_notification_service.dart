import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service to handle push notifications for application status changes
class PushNotificationService {
  static PushNotificationService? _instance;
  static PushNotificationService get instance {
    _instance ??= PushNotificationService._();
    return _instance!;
  }

  PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize push notifications
  Future<void> initialize() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ User granted notification permission');
      } else {
        debugPrint('⚠️ User declined notification permission');
        return;
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        debugPrint('✅ FCM Token: $_fcmToken');
        await _saveFCMTokenToFirestore(_fcmToken!);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _saveFCMTokenToFirestore(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      debugPrint('✅ Push notification service initialized');
    } catch (e) {
      debugPrint('❌ Error initializing push notifications: $e');
    }
  }

  /// Initialize local notifications for Android/iOS
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'application_status_channel',
      'Application Status Updates',
      description:
          'Notifications for trade license and visa application updates',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Save FCM token to user profile in Firestore
  Future<void> _saveFCMTokenToFirestore(String token) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('user_profiles').doc(userId).set({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ FCM token saved to Firestore');
    } catch (e) {
      debugPrint('❌ Error saving FCM token: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📨 Foreground message received: ${message.messageId}');

    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'Wazeet Notification',
        body: notification.body ?? '',
        payload: data.toString(),
      );
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('📨 Notification tapped: ${message.messageId}');

    final data = message.data;
    final applicationType = data['applicationType'] as String?;
    final applicationId = data['applicationId'] as String?;

    // Navigate to appropriate screen based on data
    // This will be handled by the app's navigation logic
    if (applicationType != null && applicationId != null) {
      debugPrint('Navigate to: $applicationType - $applicationId');
      // TODO: Implement navigation logic
    }
  }

  /// Callback for local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📨 Local notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'application_status_channel',
      'Application Status Updates',
      channelDescription: 'Notifications for application status changes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Send notification when application status changes
  Future<void> sendApplicationStatusNotification({
    required String userId,
    required String applicationType,
    required String applicationId,
    required String oldStatus,
    required String newStatus,
    required String applicationName,
  }) async {
    try {
      // Get user's FCM tokens
      final userDoc =
          await _firestore.collection('user_profiles').doc(userId).get();
      final fcmTokens = List<String>.from(userDoc.data()?['fcmTokens'] ?? []);

      if (fcmTokens.isEmpty) {
        debugPrint('⚠️ No FCM tokens found for user: $userId');
        return;
      }

      // Create notification payload
      final notification = {
        'title': 'Application Status Updated',
        'body': '$applicationName status changed from $oldStatus to $newStatus',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      };

      final data = {
        'applicationType': applicationType,
        'applicationId': applicationId,
        'oldStatus': oldStatus,
        'newStatus': newStatus,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save notification to Firestore for history
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': notification['title'],
        'body': notification['body'],
        'data': data,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // In a real app, you would call your backend to send FCM messages
      // For now, we'll just log it
      debugPrint('✅ Notification created for user: $userId');
      debugPrint('   Title: ${notification['title']}');
      debugPrint('   Body: ${notification['body']}');

      // TODO: Implement actual FCM sending via backend/Cloud Functions
      // This requires a backend service to send FCM messages securely
    } catch (e) {
      debugPrint('❌ Error sending notification: $e');
    }
  }

  /// Get notification history for user
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] =
              (data['createdAt'] as Timestamp).toDate().toIso8601String();
        }
        return data;
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'read': true,
        'readAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Notification marked as read: $notificationId');
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .count()
          .get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      debugPrint('✅ All notifications cleared');
    } catch (e) {
      debugPrint('❌ Error clearing notifications: $e');
    }
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📨 Background message received: ${message.messageId}');
  debugPrint('   Title: ${message.notification?.title}');
  debugPrint('   Body: ${message.notification?.body}');
}
