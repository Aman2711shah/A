import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/visa_application.dart';
import '../repositories/visa_repository.dart';

class VisaProvider extends ChangeNotifier {
  VisaProvider({
    VisaRepository? repository,
    FirebaseAuth? auth,
  })  : _repository = repository ?? VisaRepository(),
        _auth = auth ?? FirebaseAuth.instance;

  final VisaRepository _repository;
  final FirebaseAuth _auth;
  
  bool _isLoading = false;
  List<VisaApplication> _applications = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<VisaApplication> get applications => _applications;
  String? get error => _error;

  // Load applications from Firestore
  Future<void> loadApplications() async {
    final user = _auth.currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Listen to real-time updates
      _repository.getUserApplications(user.uid).listen((apps) {
        _applications = apps;
        _isLoading = false;
        _error = null;
        notifyListeners();
      }, onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _error = 'Failed to load applications: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit a new visa application
  Future<String?> submitVisaApplication(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final application = VisaApplication(
        userId: user.uid,
        companyId: data['companyId'] as String? ?? 'default',
        employeeName: data['employeeName'] as String,
        passportNumber: data['passportNumber'] as String,
        nationality: data['nationality'] as String,
        position: data['position'] as String,
        visaType: data['visaType'] as String,
        salary: data['salary'] as String,
        qualification: data['qualification'] as String? ?? '',
        status: 'submitted',
        submittedAt: DateTime.now(),
        estimatedCompletion: DateTime.now().add(const Duration(days: 10)),
        documents: data['documents'] as Map<String, dynamic>?,
        metadata: data['metadata'] as Map<String, dynamic>?,
      );

      final applicationId = await _repository.createApplication(application);
      
      _isLoading = false;
      notifyListeners();
      
      return applicationId;
    } catch (e) {
      _error = 'Failed to submit application: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update application status
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateStatus(applicationId, status);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update status: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get application by ID
  VisaApplication? getApplicationById(String id) {
    try {
      return _applications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  // Delete application
  Future<void> deleteApplication(String applicationId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteApplication(applicationId);
      _applications.removeWhere((app) => app.id == applicationId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete application: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get applications count by status
  Future<Map<String, int>> getApplicationsCountByStatus() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    try {
      return await _repository.getApplicationsCountByStatus(user.uid);
    } catch (e) {
      debugPrint('Error getting applications count: $e');
      return {};
    }
  }

  // Search applications
  Future<void> searchApplications(String query) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final results = await _repository.searchApplications(user.uid, query);
      _applications = results;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to search applications: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
