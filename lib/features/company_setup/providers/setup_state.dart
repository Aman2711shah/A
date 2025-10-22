import 'package:flutter/foundation.dart';

class SetupState extends ChangeNotifier {
  String? businessActivity;
  String? legalStructure;
  int? shareholders;
  String? tradeName;
  String? officeType;
  String? licenseType;
  String? customActivity;
  bool hasEjari = false;

  // Additional properties for complete company setup
  String? visaType;
  int? numberOfVisas;
  List<String> uploadedDocuments = [];
  bool agreedToTerms = false;
  int? selectedFreezone;
  Map<String, dynamic>? selectedFreezoneData;

  // Getters for easy access
  Map<String, dynamic> get formData => {
        'selectedActivity': businessActivity,
        'legalStructure': legalStructure,
        'numberOfShareholders': shareholders,
        'tradeName': tradeName,
        'officeType': officeType,
        'licenseType': licenseType,
        'visaType': visaType,
        'numberOfVisas': numberOfVisas,
        'uploadedDocuments': uploadedDocuments,
        'agreedToTerms': agreedToTerms,
        'selectedFreezone': selectedFreezone,
        'selectedFreezoneData': selectedFreezoneData,
        'customActivity': customActivity,
        'hasEjari': hasEjari,
      };

  bool isStepComplete(int step) {
    switch (step) {
      case 1:
        return businessActivity != null;
      case 2:
        return legalStructure != null;
      case 3:
        return shareholders != null && shareholders! > 0;
      case 4:
        return visaType != null;
      case 5:
        return officeType != null;
      case 6:
        return uploadedDocuments.isNotEmpty;
      case 7:
        return agreedToTerms;
      case 8:
        return selectedFreezone != null;
      default:
        return false;
    }
  }

  void updateStep(int step, dynamic value) {
    switch (step) {
      case 1:
        businessActivity = value;
        break;
      case 2:
        legalStructure = value;
        break;
      case 3:
        shareholders = value;
        break;
      case 4:
        visaType = value;
        break;
      case 5:
        officeType = value;
        break;
      case 6:
        uploadedDocuments = value is List<String>
            ? List<String>.from(value)
            : uploadedDocuments;
        break;
      case 7:
        agreedToTerms = value ?? false;
        break;
      case 8:
        selectedFreezone = value;
        break;
    }
    notifyListeners();
  }

  // Enhanced update methods for specific fields
  void updateBusinessActivity(String? activity) {
    businessActivity = activity;
    notifyListeners();
  }

  void updateLegalStructure(String? structure) {
    legalStructure = structure;
    notifyListeners();
  }

  void updateShareholders(int? count) {
    shareholders = count;
    notifyListeners();
  }

  void updateTradeName(String? name) {
    tradeName = name;
    notifyListeners();
  }

  void updateOfficeType(String? type) {
    officeType = type;
    notifyListeners();
  }

  void updateLicenseType(String? type) {
    licenseType = type;
    notifyListeners();
  }

  void updateCustomActivity(String? activity) {
    customActivity = activity;
    notifyListeners();
  }

  void updateHasEjari(bool value) {
    hasEjari = value;
    notifyListeners();
  }

  void updateVisaType(String? type) {
    visaType = type;
    notifyListeners();
  }

  void updateNumberOfVisas(int? count) {
    numberOfVisas = count;
    notifyListeners();
  }

  void updateUploadedDocuments(List<String> documents) {
    uploadedDocuments = documents;
    notifyListeners();
  }

  void updateAgreedToTerms(bool agreed) {
    agreedToTerms = agreed;
    notifyListeners();
  }

  void updateSelectedFreezone(int? index, Map<String, dynamic>? data) {
    selectedFreezone = index;
    selectedFreezoneData = data;
    notifyListeners();
  }

  // Generic update method for any field
  void updateField(String key, dynamic value) {
    switch (key) {
      case 'selectedActivity':
      case 'businessActivity':
        businessActivity = value;
        break;
      case 'legalStructure':
        legalStructure = value;
        break;
      case 'numberOfShareholders':
      case 'shareholders':
        shareholders = value;
        break;
      case 'tradeName':
        tradeName = value;
        break;
      case 'officeType':
        officeType = value;
        break;
      case 'licenseType':
        licenseType = value;
        break;
      case 'customActivity':
        customActivity = value;
        break;
      case 'visaType':
        visaType = value;
        break;
      case 'numberOfVisas':
        numberOfVisas = value;
        break;
      case 'uploadedDocuments':
        uploadedDocuments = value is List<String> ? value : [];
        break;
      case 'agreedToTerms':
        agreedToTerms = value ?? false;
        break;
      case 'selectedFreezone':
        selectedFreezone = value;
        break;
      case 'selectedFreezoneData':
        selectedFreezoneData = value;
        break;
      case 'hasEjari':
        hasEjari = value is bool ? value : value == true;
        break;
    }
    notifyListeners();
  }

  // Calculate completion percentage
  double get completionPercentage {
    int completedSteps = 0;
    int totalSteps = 8;

    for (int i = 1; i <= totalSteps; i++) {
      if (isStepComplete(i)) {
        completedSteps++;
      }
    }

    return completedSteps / totalSteps;
  }

  // Get current step based on completion
  int get currentStep {
    for (int i = 1; i <= 8; i++) {
      if (!isStepComplete(i)) {
        return i - 1; // Return 0-based index
      }
    }
    return 7; // All steps complete, show last step
  }

  // Validation methods
  bool get canProceedToNextStep {
    return isStepComplete(currentStep + 1);
  }

  List<String> get incompleteSteps {
    List<String> incomplete = [];
    Map<int, String> stepNames = {
      1: 'Business Activity',
      2: 'Legal Structure',
      3: 'Shareholders',
      4: 'Trade Name',
      5: 'Office Type',
      6: 'License Type',
      7: 'Terms Agreement',
      8: 'Freezone Selection',
    };

    for (int i = 1; i <= 8; i++) {
      if (!isStepComplete(i)) {
        incomplete.add(stepNames[i] ?? 'Unknown Step');
      }
    }

    return incomplete;
  }

  // Reset all data
  void reset() {
    businessActivity = null;
    legalStructure = null;
    shareholders = null;
    tradeName = null;
    officeType = null;
    licenseType = null;
    visaType = null;
    numberOfVisas = null;
    uploadedDocuments = [];
    agreedToTerms = false;
    selectedFreezone = null;
    selectedFreezoneData = null;
    customActivity = null;
    hasEjari = false;
    notifyListeners();
  }

  // Load data from external source (e.g., API or saved state)
  void loadData(Map<String, dynamic> data) {
    businessActivity = data['selectedActivity'] ?? data['businessActivity'];
    legalStructure = data['legalStructure'];
    shareholders = data['numberOfShareholders'] ?? data['shareholders'];
    tradeName = data['tradeName'];
    officeType = data['officeType'];
    licenseType = data['licenseType'];
    visaType = data['visaType'];
    numberOfVisas = data['numberOfVisas'];
    uploadedDocuments = data['uploadedDocuments'] is List<String>
        ? data['uploadedDocuments']
        : <String>[];
    agreedToTerms = data['agreedToTerms'] ?? false;
    selectedFreezone = data['selectedFreezone'];
    selectedFreezoneData = data['selectedFreezoneData'];
    customActivity = data['customActivity'];
    hasEjari = data['hasEjari'] ?? false;
    notifyListeners();
  }

  // Export data for saving or API submission
  Map<String, dynamic> toJson() {
    return {
      'businessActivity': businessActivity,
      'legalStructure': legalStructure,
      'shareholders': shareholders,
      'tradeName': tradeName,
      'officeType': officeType,
      'licenseType': licenseType,
      'visaType': visaType,
      'numberOfVisas': numberOfVisas,
      'uploadedDocuments': uploadedDocuments,
      'agreedToTerms': agreedToTerms,
      'selectedFreezone': selectedFreezone,
      'selectedFreezoneData': selectedFreezoneData,
      'completionPercentage': completionPercentage,
      'customActivity': customActivity,
      'hasEjari': hasEjari,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
