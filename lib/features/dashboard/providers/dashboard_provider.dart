import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  int _activeApplications = 3;
  int _completedApplications = 7;
  int _pendingDocuments = 2;
  
  List<Map<String, dynamic>> _recentApplications = [];
  List<Map<String, dynamic>> _notifications = [];

  bool get isLoading => _isLoading;
  int get activeApplications => _activeApplications;
  int get completedApplications => _completedApplications;
  int get pendingDocuments => _pendingDocuments;
  List<Map<String, dynamic>> get recentApplications => _recentApplications;
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _recentApplications = [
        {
          'title': 'ABC Trading LLC',
          'subtitle': 'Company Formation',
          'status': 'In Review',
          'date': '2024-01-15',
        },
        {
          'title': 'Trade License Application',
          'subtitle': 'General Trading',
          'status': 'Pending',
          'date': '2024-01-12',
        },
        {
          'title': 'Employee Visa',
          'subtitle': 'Marketing Manager',
          'status': 'Approved',
          'date': '2024-01-10',
        },
      ];
      
      _notifications = [
        {
          'title': 'Application Update',
          'message': 'Your company formation application is under review',
          'time': '2 hours ago',
          'isRead': false,
        },
        {
          'title': 'Document Required',
          'message': 'Please upload your passport copy for visa processing',
          'time': '1 day ago',
          'isRead': true,
        },
        {
          'title': 'Payment Confirmed',
          'message': 'Your payment for trade license has been processed',
          'time': '3 days ago',
          'isRead': true,
        },
      ];
      
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateApplicationStatus(String applicationId, String status) {
    final index = _recentApplications.indexWhere(
      (app) => app['id'] == applicationId,
    );
    
    if (index != -1) {
      _recentApplications[index]['status'] = status;
      notifyListeners();
    }
  }

  void markNotificationAsRead(int index) {
    if (index < _notifications.length) {
      _notifications[index]['isRead'] = true;
      notifyListeners();
    }
  }

  void addNotification(Map<String, dynamic> notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void updateStats({
    int? activeApplications,
    int? completedApplications,
    int? pendingDocuments,
  }) {
    if (activeApplications != null) _activeApplications = activeApplications;
    if (completedApplications != null) _completedApplications = completedApplications;
    if (pendingDocuments != null) _pendingDocuments = pendingDocuments;
    notifyListeners();
  }
}
