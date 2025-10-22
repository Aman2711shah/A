import 'package:flutter/foundation.dart';

class GrowthState extends ChangeNotifier {
  // Step 1: Service Category Selection
  String? selectedCategory;

  // Step 2: Service Selection
  String? selectedService;
  Map<String, dynamic>? selectedServiceData;

  // Step 3: Package Selection (Premium or Standard)
  String? selectedPackage; // 'premium' or 'standard'

  // Step 4: Contact Information
  String? fullName;
  String? email;
  String? phone;
  String? companyName;
  String? preferredContactMethod;
  String? message;

  // Step 5: Document Upload
  List<String> uploadedDocuments = [];

  // Step 6: Review & Confirmation
  bool agreedToTerms = false;

  // Getters for easy access
  Map<String, dynamic> get formData => {
        'selectedCategory': selectedCategory,
        'selectedService': selectedService,
        'selectedServiceData': selectedServiceData,
        'selectedPackage': selectedPackage,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'companyName': companyName,
        'preferredContactMethod': preferredContactMethod,
        'message': message,
        'uploadedDocuments': uploadedDocuments,
        'agreedToTerms': agreedToTerms,
      };

  bool isStepComplete(int step) {
    switch (step) {
      case 1:
        return selectedCategory != null;
      case 2:
        return selectedService != null;
      case 3:
        return selectedPackage != null;
      case 4:
        return fullName != null &&
            fullName!.isNotEmpty &&
            email != null &&
            email!.isNotEmpty &&
            phone != null &&
            phone!.isNotEmpty;
      case 5:
        return uploadedDocuments.isNotEmpty;
      case 6:
        return agreedToTerms;
      default:
        return false;
    }
  }

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'selectedCategory':
        selectedCategory = value;
        // Reset service selection when category changes
        selectedService = null;
        selectedServiceData = null;
        break;
      case 'selectedService':
        selectedService = value;
        break;
      case 'selectedServiceData':
        selectedServiceData = value;
        break;
      case 'selectedPackage':
        selectedPackage = value;
        break;
      case 'fullName':
        fullName = value;
        break;
      case 'email':
        email = value;
        break;
      case 'phone':
        phone = value;
        break;
      case 'companyName':
        companyName = value;
        break;
      case 'preferredContactMethod':
        preferredContactMethod = value;
        break;
      case 'message':
        message = value;
        break;
      case 'uploadedDocuments':
        uploadedDocuments = value is List<String> ? value : [];
        break;
      case 'agreedToTerms':
        agreedToTerms = value is bool ? value : value == true;
        break;
    }
    notifyListeners();
  }

  // Calculate completion percentage
  double get completionPercentage {
    int completedSteps = 0;
    int totalSteps = 6;

    for (int i = 1; i <= totalSteps; i++) {
      if (isStepComplete(i)) {
        completedSteps++;
      }
    }

    return completedSteps / totalSteps;
  }

  // Get current step based on completion
  int get currentStep {
    for (int i = 1; i <= 6; i++) {
      if (!isStepComplete(i)) {
        return i - 1; // Return 0-based index
      }
    }
    return 5; // All steps complete, show last step
  }

  // Get estimated cost
  double getEstimatedCost() {
    if (selectedServiceData == null || selectedPackage == null) return 0;

    if (selectedPackage == 'premium') {
      return (selectedServiceData!['Premium Charges (AED)'] ?? 0).toDouble();
    } else {
      return (selectedServiceData!['Standard Charges (AED)'] ?? 0).toDouble();
    }
  }

  // Get estimated timeline
  String getEstimatedTimeline() {
    if (selectedServiceData == null || selectedPackage == null) {
      return 'N/A';
    }

    if (selectedPackage == 'premium') {
      return selectedServiceData!['Premium Timeline'] ?? 'N/A';
    } else {
      return selectedServiceData!['Standard Timeline'] ?? 'N/A';
    }
  }

  // Reset all data
  void reset() {
    selectedCategory = null;
    selectedService = null;
    selectedServiceData = null;
    selectedPackage = null;
    fullName = null;
    email = null;
    phone = null;
    companyName = null;
    preferredContactMethod = null;
    message = null;
    uploadedDocuments = [];
    agreedToTerms = false;
    notifyListeners();
  }

  // Export data for saving or API submission
  Map<String, dynamic> toJson() {
    return {
      'selectedCategory': selectedCategory,
      'selectedService': selectedService,
      'selectedServiceData': selectedServiceData,
      'selectedPackage': selectedPackage,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'companyName': companyName,
      'preferredContactMethod': preferredContactMethod,
      'message': message,
      'uploadedDocuments': uploadedDocuments,
      'agreedToTerms': agreedToTerms,
      'estimatedCost': getEstimatedCost(),
      'estimatedTimeline': getEstimatedTimeline(),
      'completionPercentage': completionPercentage,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
