import 'package:flutter/material.dart';

class TradeLicenseProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _applications = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get applications => _applications;

  Future<void> loadApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _applications = [
        {
          'id': 'TL_001',
          'companyName': 'ABC Trading LLC',
          'tradeName': 'ABC Trading',
          'licenseType': 'Commercial License',
          'businessActivity': 'General Trading',
          'status': 'In Review',
          'submittedAt': '2024-01-15T10:30:00Z',
          'estimatedCompletion': '2024-01-22T10:30:00Z',
        },
        {
          'id': 'TL_002',
          'companyName': 'XYZ Services LLC',
          'tradeName': 'XYZ Services',
          'licenseType': 'Professional License',
          'businessActivity': 'Consulting Services',
          'status': 'Approved',
          'submittedAt': '2024-01-10T14:20:00Z',
          'estimatedCompletion': '2024-01-17T14:20:00Z',
        },
      ];
      
    } catch (e) {
      debugPrint('Error loading trade license applications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitTradeLicenseApplication(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful submission
      final application = {
        'id': 'TL_${DateTime.now().millisecondsSinceEpoch}',
        'companyName': data['companyName'],
        'tradeName': data['tradeName'],
        'licenseType': data['licenseType'],
        'businessActivity': data['businessActivity'],
        'status': 'Submitted',
        'submittedAt': DateTime.now().toIso8601String(),
        'estimatedCompletion': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };
      
      _applications.add(application);
      
    } catch (e) {
      debugPrint('Error submitting trade license application: $e');
      rethrow;
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

  Map<String, dynamic>? getApplicationById(String id) {
    try {
      return _applications.firstWhere((app) => app['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
