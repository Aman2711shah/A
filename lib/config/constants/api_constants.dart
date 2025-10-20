class ApiConstants {
  static const String baseUrl = 'https://your-api-url.com/v1'; // Update with your actual API URL
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // Company Setup Endpoints
  static const String activities = '/company-setup/activities';
  static const String saveDraft = '/company-setup/save-draft';
  static const String calculateCost = '/company-setup/calculate-cost';
  
  // Trade License Endpoints
  static const String applyTradeLicense = '/trade-license/apply';
  static const String getPackages = '/trade-license/packages';
  static const String getApplications = '/trade-license/applications';
  
  // Document Endpoints
  static const String uploadDocument = '/documents/upload';
  static const String getDocuments = '/documents';
  
  // Visa Endpoints
  static const String applyVisa = '/visa-immigration/apply';
  static const String trackVisa = '/visa-immigration/track';
  
  // Services Endpoints
  static const String getServices = '/services';
  static const String bookConsultation = '/services/consultation/book';
}