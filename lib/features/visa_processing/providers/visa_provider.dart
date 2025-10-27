import 'package:flutter/material.dart';
import '../../../core/services/firestore/visa_firestore_service.dart';

class VisaProvider extends ChangeNotifier {
  VisaProvider({
    List<Map<String, dynamic>>? initialApplications,
  }) : _applications = initialApplications ?? [];

  final _firestoreService = VisaFirestoreService.instance;

  bool _isLoading = false;
  List<Map<String, dynamic>> _applications;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get applications => _applications;

  Future<void> loadApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load applications from Firestore
      _applications = await _firestoreService.getUserApplications();
      debugPrint('✅ Loaded ${_applications.length} visa applications from Firestore');
    } catch (e) {
      debugPrint('❌ Error loading visa applications: $e');
      _applications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> submitVisaApplication(
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Submit application to Firestore
      final applicationId = await _firestoreService.submitApplication(data);

      // Reload applications to get the updated list
      await loadApplications();

      debugPrint('✅ Visa application submitted: $applicationId');
      return applicationId;
    } catch (e) {
      debugPrint('❌ Error submitting visa application: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateApplicationStatus(String applicationId, String status) async {
    try {
      await _firestoreService.updateApplicationStatus(applicationId, status);
      
      // Update local cache
      final index = _applications.indexWhere((app) => app['id'] == applicationId);
      if (index != -1) {
        _applications[index]['status'] = status;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating visa application status: $e');
      rethrow;
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

  /// Stream applications for real-time updates
  Stream<List<Map<String, dynamic>>> streamApplications() {
    return _firestoreService.streamUserApplications();
  }
}
