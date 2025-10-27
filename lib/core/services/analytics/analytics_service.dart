import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Service to track analytics events across the app
class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance {
    _instance ??= AnalyticsService._();
    return _instance!;
  }

  AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Set user ID for tracking
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('✅ Analytics user ID set: $userId');
    } catch (e) {
      debugPrint('❌ Error setting user ID: $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('✅ User property set: $name = $value');
    } catch (e) {
      debugPrint('❌ Error setting user property: $e');
    }
  }

  /// Log screen view
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenName,
      );
      debugPrint('📊 Screen view: $screenName');
    } catch (e) {
      debugPrint('❌ Error logging screen view: $e');
    }
  }

  /// Log trade license application started
  Future<void> logTradeLicenseStarted({
    required String jurisdiction,
    required String freezoneName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'trade_license_started',
        parameters: {
          'jurisdiction': jurisdiction,
          'freezone_name': freezoneName,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Trade license started: $freezoneName');
    } catch (e) {
      debugPrint('❌ Error logging trade license start: $e');
    }
  }

  /// Log trade license application submitted
  Future<void> logTradeLicenseSubmitted({
    required String applicationId,
    required String freezoneName,
    required String packageName,
    required double priceAED,
    required int visasIncluded,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'trade_license_submitted',
        parameters: {
          'application_id': applicationId,
          'freezone_name': freezoneName,
          'package_name': packageName,
          'price_aed': priceAED,
          'visas_included': visasIncluded,
          'currency': 'AED',
          'value': priceAED,
        },
      );
      debugPrint('📊 Trade license submitted: $applicationId');
    } catch (e) {
      debugPrint('❌ Error logging trade license submission: $e');
    }
  }

  /// Log visa application submitted
  Future<void> logVisaSubmitted({
    required String applicationId,
    required String visaType,
    required String nationality,
    String? position,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'visa_submitted',
        parameters: {
          'application_id': applicationId,
          'visa_type': visaType,
          'nationality': nationality,
          if (position != null) 'position': position,
        },
      );
      debugPrint('📊 Visa submitted: $applicationId');
    } catch (e) {
      debugPrint('❌ Error logging visa submission: $e');
    }
  }

  /// Log company setup started
  Future<void> logCompanySetupStarted({
    required String legalStructure,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'company_setup_started',
        parameters: {
          'legal_structure': legalStructure,
        },
      );
      debugPrint('📊 Company setup started: $legalStructure');
    } catch (e) {
      debugPrint('❌ Error logging company setup start: $e');
    }
  }

  /// Log company setup completed
  Future<void> logCompanySetupCompleted({
    required String setupId,
    required String legalStructure,
    required int stepCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'company_setup_completed',
        parameters: {
          'setup_id': setupId,
          'legal_structure': legalStructure,
          'step_count': stepCount,
        },
      );
      debugPrint('📊 Company setup completed: $setupId');
    } catch (e) {
      debugPrint('❌ Error logging company setup completion: $e');
    }
  }

  /// Log application status changed
  Future<void> logApplicationStatusChanged({
    required String applicationId,
    required String applicationType,
    required String oldStatus,
    required String newStatus,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'application_status_changed',
        parameters: {
          'application_id': applicationId,
          'application_type': applicationType,
          'old_status': oldStatus,
          'new_status': newStatus,
        },
      );
      debugPrint('📊 Status changed: $oldStatus → $newStatus');
    } catch (e) {
      debugPrint('❌ Error logging status change: $e');
    }
  }

  /// Log package selected
  Future<void> logPackageSelected({
    required String freezoneName,
    required String packageName,
    required double priceAED,
    required int visasIncluded,
    required int tenureYears,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'package_selected',
        parameters: {
          'freezone_name': freezoneName,
          'package_name': packageName,
          'price_aed': priceAED,
          'visas_included': visasIncluded,
          'tenure_years': tenureYears,
          'currency': 'AED',
          'value': priceAED,
        },
      );
      debugPrint('📊 Package selected: $packageName');
    } catch (e) {
      debugPrint('❌ Error logging package selection: $e');
    }
  }

  /// Log package comparison viewed
  Future<void> logPackageComparisonViewed({
    required String freezoneName,
    required int packageCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'package_comparison_viewed',
        parameters: {
          'freezone_name': freezoneName,
          'package_count': packageCount,
        },
      );
      debugPrint('📊 Package comparison viewed: $freezoneName');
    } catch (e) {
      debugPrint('❌ Error logging package comparison: $e');
    }
  }

  /// Log search performed
  Future<void> logSearch({
    required String searchTerm,
    required String searchType,
    int? resultCount,
  }) async {
    try {
      await _analytics.logSearch(
        searchTerm: searchTerm,
        parameters: {
          'search_type': searchType,
          if (resultCount != null) 'result_count': resultCount,
        },
      );
      debugPrint('📊 Search: $searchTerm');
    } catch (e) {
      debugPrint('❌ Error logging search: $e');
    }
  }

  /// Log filter applied
  Future<void> logFilterApplied({
    required String filterType,
    required String filterValue,
    int? resultCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'filter_applied',
        parameters: {
          'filter_type': filterType,
          'filter_value': filterValue,
          if (resultCount != null) 'result_count': resultCount,
        },
      );
      debugPrint('📊 Filter applied: $filterType = $filterValue');
    } catch (e) {
      debugPrint('❌ Error logging filter: $e');
    }
  }

  /// Log document uploaded
  Future<void> logDocumentUploaded({
    required String documentType,
    required String fileExtension,
    required int fileSizeKB,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'document_uploaded',
        parameters: {
          'document_type': documentType,
          'file_extension': fileExtension,
          'file_size_kb': fileSizeKB,
        },
      );
      debugPrint('📊 Document uploaded: $documentType');
    } catch (e) {
      debugPrint('❌ Error logging document upload: $e');
    }
  }

  /// Log PDF export
  Future<void> logPDFExported({
    required String documentType,
    required String applicationId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'pdf_exported',
        parameters: {
          'document_type': documentType,
          'application_id': applicationId,
        },
      );
      debugPrint('📊 PDF exported: $documentType');
    } catch (e) {
      debugPrint('❌ Error logging PDF export: $e');
    }
  }

  /// Log user sign up
  Future<void> logSignUp({
    required String method,
  }) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
      debugPrint('📊 User signed up: $method');
    } catch (e) {
      debugPrint('❌ Error logging sign up: $e');
    }
  }

  /// Log user login
  Future<void> logLogin({
    required String method,
  }) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      debugPrint('📊 User logged in: $method');
    } catch (e) {
      debugPrint('❌ Error logging login: $e');
    }
  }

  /// Log error
  Future<void> logError({
    required String error,
    required String location,
    String? stackTrace,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'error_occurred',
        parameters: {
          'error': error,
          'location': location,
          if (stackTrace != null) 'stack_trace': stackTrace.substring(0, 100),
        },
      );
      debugPrint('📊 Error logged: $error');
    } catch (e) {
      debugPrint('❌ Error logging error: $e');
    }
  }

  /// Log feature used
  Future<void> logFeatureUsed({
    required String featureName,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'feature_used',
        parameters: {
          'feature_name': featureName,
          ...?additionalParams,
        },
      );
      debugPrint('📊 Feature used: $featureName');
    } catch (e) {
      debugPrint('❌ Error logging feature usage: $e');
    }
  }

  /// Log notification received
  Future<void> logNotificationReceived({
    required String notificationType,
    required String applicationId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'notification_received',
        parameters: {
          'notification_type': notificationType,
          'application_id': applicationId,
        },
      );
      debugPrint('📊 Notification received: $notificationType');
    } catch (e) {
      debugPrint('❌ Error logging notification: $e');
    }
  }

  /// Log notification opened
  Future<void> logNotificationOpened({
    required String notificationType,
    required String applicationId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'notification_opened',
        parameters: {
          'notification_type': notificationType,
          'application_id': applicationId,
        },
      );
      debugPrint('📊 Notification opened: $notificationType');
    } catch (e) {
      debugPrint('❌ Error logging notification open: $e');
    }
  }

  /// Track conversion funnel step
  Future<void> logFunnelStep({
    required String funnelName,
    required String stepName,
    required int stepNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'funnel_step',
        parameters: {
          'funnel_name': funnelName,
          'step_name': stepName,
          'step_number': stepNumber,
          ...?additionalData,
        },
      );
      debugPrint('📊 Funnel step: $funnelName - $stepName');
    } catch (e) {
      debugPrint('❌ Error logging funnel step: $e');
    }
  }

  /// Track time spent on screen
  Future<void> logTimeSpent({
    required String screenName,
    required int durationSeconds,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'time_spent',
        parameters: {
          'screen_name': screenName,
          'duration_seconds': durationSeconds,
        },
      );
      debugPrint('📊 Time spent on $screenName: ${durationSeconds}s');
    } catch (e) {
      debugPrint('❌ Error logging time spent: $e');
    }
  }
}
