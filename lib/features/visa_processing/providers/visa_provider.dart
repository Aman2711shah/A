import 'package:flutter/material.dart';

class VisaProvider extends ChangeNotifier {
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
          'id': 'VISA_001',
          'employeeName': 'Ahmed Hassan',
          'passportNumber': 'A1234567',
          'position': 'Marketing Manager',
          'visaType': 'Employment Visa',
          'nationality': 'Egyptian',
          'salary': '8000',
          'status': 'Under Process',
          'submittedAt': '2024-01-15T10:30:00Z',
          'estimatedCompletion': '2024-01-25T10:30:00Z',
        },
        {
          'id': 'VISA_002',
          'employeeName': 'Priya Sharma',
          'passportNumber': 'B9876543',
          'position': 'Software Developer',
          'visaType': 'Employment Visa',
          'nationality': 'Indian',
          'salary': '12000',
          'status': 'Approved',
          'submittedAt': '2024-01-10T14:20:00Z',
          'estimatedCompletion': '2024-01-20T14:20:00Z',
        },
        {
          'id': 'VISA_003',
          'employeeName': 'Mohammed Ali',
          'passportNumber': 'C5555555',
          'position': 'Sales Executive',
          'visaType': 'Employment Visa',
          'nationality': 'Pakistani',
          'salary': '6000',
          'status': 'In Review',
          'submittedAt': '2024-01-18T09:15:00Z',
          'estimatedCompletion': '2024-01-28T09:15:00Z',
        },
      ];
      
    } catch (e) {
      debugPrint('Error loading visa applications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitVisaApplication(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful submission
      final application = {
        'id': 'VISA_${DateTime.now().millisecondsSinceEpoch}',
        'employeeName': data['employeeName'],
        'passportNumber': data['passportNumber'],
        'position': data['position'],
        'visaType': data['visaType'],
        'nationality': data['nationality'],
        'salary': data['salary'],
        'status': 'Submitted',
        'submittedAt': DateTime.now().toIso8601String(),
        'estimatedCompletion': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
      };
      
      _applications.add(application);
      
    } catch (e) {
      debugPrint('Error submitting visa application: $e');
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

  List<Map<String, dynamic>> getApplicationsByStatus(String status) {
    return _applications.where((app) => app['status'] == status).toList();
  }
}
