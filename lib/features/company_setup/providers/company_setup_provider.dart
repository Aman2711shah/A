import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/wizard_persistence_service.dart';
import '../../../core/services/firebase_firestore_service.dart';

class CompanySetupProvider extends ChangeNotifier {
  int _currentStep = 0;
  final int _totalSteps = 7;

  // Form data
  String? _selectedActivity;
  String? _customActivityDetails;
  String? _selectedLegalStructure;
  int _numberOfShareholders = 1;
  String? _visaType;
  int _numberOfVisas = 0;
  String? _officeSpaceType;
  bool _hasEjari = false;
  final List<String> _uploadedDocuments = [];
  final Map<String, Map<String, dynamic>> _uploadedDocumentDetails = {};

  bool _isLoading = false;
  bool _autoSaveEnabled = true;

  // Getters
  int get currentStep => _currentStep;
  int get totalSteps => _totalSteps;
  String? get selectedActivity => _selectedActivity;
  String? get customActivityDetails => _customActivityDetails;
  String? get selectedLegalStructure => _selectedLegalStructure;
  int get numberOfShareholders => _numberOfShareholders;
  String? get visaType => _visaType;
  int get numberOfVisas => _numberOfVisas;
  String? get officeSpaceType => _officeSpaceType;
  bool get hasEjari => _hasEjari;
  List<String> get uploadedDocuments => _uploadedDocuments;
  Map<String, Map<String, dynamic>> get uploadedDocumentDetails =>
      _uploadedDocumentDetails;
  bool get isLoading => _isLoading;
  bool get autoSaveEnabled => _autoSaveEnabled;

  // Initialize and load saved progress
  Future<void> initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _autoSaveEnabled) {
      await loadProgress(user.uid);
    }
  }

  // Save progress to local storage
  Future<void> saveProgress() async {
    if (!_autoSaveEnabled) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final formData = {
      'selectedActivity': _selectedActivity,
      'customActivityDetails': _customActivityDetails,
      'selectedLegalStructure': _selectedLegalStructure,
      'numberOfShareholders': _numberOfShareholders,
      'visaType': _visaType,
      'numberOfVisas': _numberOfVisas,
      'officeSpaceType': _officeSpaceType,
      'hasEjari': _hasEjari,
      'uploadedDocuments': _uploadedDocuments,
      'uploadedDocumentDetails': _uploadedDocumentDetails,
    };

    await WizardPersistenceService.saveProgress(
      userId: user.uid,
      currentStep: _currentStep,
      formData: formData,
    );
  }

  // Load progress from local storage
  Future<bool> loadProgress(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await WizardPersistenceService.loadProgress(userId);
      if (data == null) return false;

      final formData = data['form_data'] as Map<String, dynamic>;

      _currentStep = data['current_step'] as int? ?? 0;
      _selectedActivity = formData['selectedActivity'] as String?;
      _customActivityDetails = formData['customActivityDetails'] as String?;
      _selectedLegalStructure = formData['selectedLegalStructure'] as String?;
      _numberOfShareholders = formData['numberOfShareholders'] as int? ?? 1;
      _visaType = formData['visaType'] as String?;
      _numberOfVisas = formData['numberOfVisas'] as int? ?? 0;
      _officeSpaceType = formData['officeSpaceType'] as String?;
      _hasEjari = formData['hasEjari'] as bool? ?? false;

      final docs = formData['uploadedDocuments'];
      if (docs is List) {
        _uploadedDocuments.clear();
        _uploadedDocuments.addAll(docs.cast<String>());
      }

      final docDetails = formData['uploadedDocumentDetails'];
      if (docDetails is Map) {
        _uploadedDocumentDetails.clear();
        docDetails.forEach((key, value) {
          if (value is Map) {
            _uploadedDocumentDetails[key.toString()] =
                Map<String, dynamic>.from(value);
          }
        });
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error loading progress: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear saved progress
  Future<void> clearProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await WizardPersistenceService.clearProgress(user.uid);
    }
  }

  // Check if saved progress exists
  Future<bool> hasSavedProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return await WizardPersistenceService.hasSavedProgress(user.uid);
  }

  // Toggle auto-save
  void setAutoSave(bool enabled) {
    _autoSaveEnabled = enabled;
    notifyListeners();
  }

  // Navigation
  void nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _currentStep++;
      notifyListeners();
      saveProgress(); // Auto-save on navigation
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
      saveProgress(); // Auto-save on navigation
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      _currentStep = step;
      notifyListeners();
      saveProgress(); // Auto-save on navigation
    }
  }

  // Form data setters
  void setSelectedActivity(String activity) {
    _selectedActivity = activity;
    if (activity != 'other') {
      _customActivityDetails = null;
    }
    notifyListeners();
    saveProgress();
  }

  void setCustomActivity(String details) {
    _customActivityDetails = details;
    notifyListeners();
    saveProgress();
  }

  void setSelectedLegalStructure(String structure) {
    _selectedLegalStructure = structure;
    notifyListeners();
    saveProgress();
  }

  void setNumberOfShareholders(int count) {
    _numberOfShareholders = count;
    notifyListeners();
    saveProgress();
  }

  void setVisaType(String type) {
    _visaType = type;
    notifyListeners();
    saveProgress();
  }

  void setNumberOfVisas(int count) {
    _numberOfVisas = count;
    notifyListeners();
    saveProgress();
  }

  void setOfficeSpaceType(String type) {
    _officeSpaceType = type;
    notifyListeners();
    saveProgress();
  }

  void setHasEjari(bool hasEjari) {
    _hasEjari = hasEjari;
    notifyListeners();
    saveProgress();
  }

  void addDocument(String document, {Map<String, dynamic>? details}) {
    _uploadedDocuments.add(document);
    if (details != null) {
      _uploadedDocumentDetails[document] = details;
    }
    notifyListeners();
    saveProgress();
  }

  void removeDocument(String document) {
    _uploadedDocuments.remove(document);
    _uploadedDocumentDetails.remove(document);
    notifyListeners();
    saveProgress();
  }

  // Get document details
  Map<String, dynamic>? getDocumentDetails(String documentId) {
    return _uploadedDocumentDetails[documentId];
  }

  // Validation
  bool isStepValid(int step) {
    switch (step) {
      case 0:
        return _selectedActivity != null;
      case 1:
        return _selectedLegalStructure != null;
      case 2:
        return _numberOfShareholders > 0;
      case 3:
        return _visaType != null;
      case 4:
        return _officeSpaceType != null;
      case 5:
        return _uploadedDocuments.isNotEmpty;
      case 6:
        return true; // Review step is always valid
      default:
        return false;
    }
  }

  bool get canProceed => isStepValid(_currentStep);

  // Reset form
  void resetForm() {
    _currentStep = 0;
    _selectedActivity = null;
    _selectedLegalStructure = null;
    _numberOfShareholders = 1;
    _visaType = null;
    _numberOfVisas = 0;
    _officeSpaceType = null;
    _hasEjari = false;
    _uploadedDocuments.clear();
    _uploadedDocumentDetails.clear();
    notifyListeners();
    clearProgress(); // Clear saved progress
  }

  // Submit form
  Future<String> submitForm() async {
    _isLoading = true;
    notifyListeners();

    try {
      final firestoreService = FirestoreService();

      // Prepare submission data
      final submissionData = {
        'type': 'company_setup',
        'activity': _selectedActivity,
        'legalStructure': _selectedLegalStructure,
        'numberOfShareholders': _numberOfShareholders,
        'visaType': _visaType,
        'numberOfVisas': _numberOfVisas,
        'officeSpaceType': _officeSpaceType,
        'hasEjari': _hasEjari,
        'documents': _uploadedDocuments.map((docId) {
          final details = _uploadedDocumentDetails[docId];
          return details ?? {'id': docId, 'name': docId};
        }).toList(),
        'status': 'pending',
        'progressPercentage': 0,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'nextSteps':
            'Your application is being reviewed by our team. We will contact you within 24-48 hours.',
      };

      // Submit to Firestore
      final applicationId =
          await firestoreService.createApplication(submissionData);

      // Clear saved progress after successful submission
      await clearProgress();

      debugPrint('Company setup submitted successfully: $applicationId');
      return applicationId;
    } catch (e) {
      debugPrint('Error submitting form: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get form data as map
  Map<String, dynamic> getFormData() {
    return {
      'selectedActivity': _selectedActivity,
      'selectedLegalStructure': _selectedLegalStructure,
      'numberOfShareholders': _numberOfShareholders,
      'visaType': _visaType,
      'numberOfVisas': _numberOfVisas,
      'officeSpaceType': _officeSpaceType,
      'hasEjari': _hasEjari,
      'uploadedDocuments': _uploadedDocuments,
      'uploadedDocumentDetails': _uploadedDocumentDetails,
    };
  }
}
