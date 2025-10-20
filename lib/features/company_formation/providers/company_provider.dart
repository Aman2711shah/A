import 'package:flutter/material.dart';

class CompanyProvider extends ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic> _companyData = {};
  List<Map<String, dynamic>> _applications = [];

  bool get isLoading => _isLoading;
  Map<String, dynamic> get companyData => _companyData;
  List<Map<String, dynamic>> get applications => _applications;

  Future<void> submitCompanyApplication() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful submission
      final application = {
        'id': 'APP_${DateTime.now().millisecondsSinceEpoch}',
        'type': 'Company Formation',
        'status': 'Submitted',
        'submittedAt': DateTime.now().toIso8601String(),
        'estimatedCompletion': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };
      
      _applications.add(application);
      
    } catch (e) {
      debugPrint('Error submitting company application: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _applications = [
        {
          'id': 'APP_001',
          'type': 'Company Formation',
          'status': 'In Review',
          'submittedAt': '2024-01-15T10:30:00Z',
          'estimatedCompletion': '2024-01-22T10:30:00Z',
          'companyName': 'ABC Trading LLC',
          'tradeName': 'ABC Trading',
          'businessActivity': 'General Trading',
          'capital': '100000',
        },
        {
          'id': 'APP_002',
          'type': 'Company Formation',
          'status': 'Approved',
          'submittedAt': '2024-01-10T14:20:00Z',
          'estimatedCompletion': '2024-01-17T14:20:00Z',
          'companyName': 'XYZ Services LLC',
          'tradeName': 'XYZ Services',
          'businessActivity': 'Consulting Services',
          'capital': '50000',
        },
      ];
      
    } catch (e) {
      debugPrint('Error loading applications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateApplicationStatus(String applicationId, String status) {
    final index = _applications.indexWhere((app) => app['id'] == applicationId);
    
    if (index != -1) {
      _applications[index]['status'] = status;
      notifyListeners();
    }
  }

  void setCompanyData(Map<String, dynamic> data) {
    _companyData = data;
    notifyListeners();
  }

  Map<String, dynamic>? getApplicationById(String id) {
    try {
      return _applications.firstWhere((app) => app['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
