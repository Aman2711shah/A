import 'package:flutter/material.dart';
import '../../../core/services/firestore/trade_license_firestore_service.dart';

class TradeLicenseProvider extends ChangeNotifier {
  TradeLicenseProvider({
    List<Map<String, dynamic>>? initialApplications,
    TradeLicenseDataSource? dataSource,
  })  : _applications = initialApplications ?? [],
        _dataSource = dataSource ?? TradeLicenseFirestoreService.instance;

  final TradeLicenseDataSource _dataSource;

  bool _isLoading = false;
  List<Map<String, dynamic>> _applications;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get applications => _applications;

  Future<void> loadApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load applications from Firestore
      _applications = await _dataSource.getUserApplications();
      debugPrint('✅ Loaded ${_applications.length} applications from Firestore');
    } catch (e) {
      debugPrint('❌ Error loading trade license applications: $e');
      _applications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> submitTradeLicenseApplication(
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Submit application to Firestore
      final applicationId = await _dataSource.submitApplication(data);

      // Reload applications to get the updated list
      await loadApplications();

      debugPrint('✅ Trade license application submitted: $applicationId');
      return applicationId;
    } catch (e) {
      debugPrint('❌ Error submitting trade license application: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateApplicationStatus(String applicationId, String status) async {
    try {
      await _dataSource.updateApplicationStatus(applicationId, status);
      
      // Update local cache
      final index = _applications.indexWhere((app) => app['id'] == applicationId);
      if (index != -1) {
        _applications[index]['status'] = status;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating application status: $e');
      rethrow;
    }
  }

  Map<String, dynamic>? getApplicationById(String id) {
    try {
      return _applications.firstWhere((app) => app['id'] == id);
    } catch (_) {
      return null;
    }
  }

  /// Stream applications for real-time updates
  Stream<List<Map<String, dynamic>>> streamApplications() {
    return _dataSource.streamUserApplications();
  }
}
