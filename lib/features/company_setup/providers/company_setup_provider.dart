import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/firebase_firestore_service.dart';

class CompanySetupProvider extends ChangeNotifier {
  CompanySetupProvider({
    FirebaseAuth? firebaseAuth,
    FirestoreService? firestoreService,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestoreService = firestoreService ?? FirestoreService();

  int _currentStep = 0;
  final int _totalSteps = 7;

  final FirebaseAuth _auth;
  final FirestoreService _firestoreService;

  // Form data
  String? _selectedActivity;
  String? _selectedLegalStructure;
  int _numberOfShareholders = 1;
  String? _visaType;
  int _numberOfVisas = 0;
  String? _officeSpaceType;
  bool _hasEjari = false;
  final List<String> _uploadedDocuments = [];
  String? _lastApplicationId;

  // Getters
  int get currentStep => _currentStep;
  int get totalSteps => _totalSteps;
  String? get selectedActivity => _selectedActivity;
  String? get selectedLegalStructure => _selectedLegalStructure;
  int get numberOfShareholders => _numberOfShareholders;
  String? get visaType => _visaType;
  int get numberOfVisas => _numberOfVisas;
  String? get officeSpaceType => _officeSpaceType;
  bool get hasEjari => _hasEjari;
  List<String> get uploadedDocuments => _uploadedDocuments;
  String? get lastApplicationId => _lastApplicationId;

  // Navigation
  void nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Form data setters
  void setSelectedActivity(String activity) {
    _selectedActivity = activity;
    notifyListeners();
  }

  void setSelectedLegalStructure(String structure) {
    _selectedLegalStructure = structure;
    notifyListeners();
  }

  void setNumberOfShareholders(int count) {
    _numberOfShareholders = count;
    notifyListeners();
  }

  void setVisaType(String type) {
    _visaType = type;
    notifyListeners();
  }

  void setNumberOfVisas(int count) {
    _numberOfVisas = count;
    notifyListeners();
  }

  void setOfficeSpaceType(String type) {
    _officeSpaceType = type;
    notifyListeners();
  }

  void setHasEjari(bool hasEjari) {
    _hasEjari = hasEjari;
    notifyListeners();
  }

  void addDocument(String document) {
    _uploadedDocuments.add(document);
    notifyListeners();
  }

  void removeDocument(String document) {
    _uploadedDocuments.remove(document);
    notifyListeners();
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
    notifyListeners();
  }

  // Submit form
  Future<String> submitForm() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You need to be signed in to submit an application.');
    }

    final applicationPayload = {
      'userId': user.uid,
      'userEmail': user.email,
      'type': 'company_setup',
      'status': 'pending',
      'activity': _selectedActivity,
      'legalStructure': _selectedLegalStructure,
      'shareholders': _numberOfShareholders,
      'visaType': _visaType,
      'numberOfVisas': _numberOfVisas,
      'officeSpaceType': _officeSpaceType,
      'hasEjari': _hasEjari,
      'documents': List<String>.from(_uploadedDocuments),
    };

    final applicationId =
        await _firestoreService.createApplication(applicationPayload);

    _lastApplicationId = applicationId;

    debugPrint('Company setup application submitted: $applicationPayload');

    return applicationId;
  }
}
