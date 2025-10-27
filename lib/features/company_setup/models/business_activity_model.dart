class BusinessActivityModel {
  final String activityMasterNumber;
  final String isicCode;
  final String activityName;
  final String activityNameArabic;
  final String description;
  final String descriptionArabic;
  final String allowedFacilityType;
  final String allowedSubFacility;
  final String brandName;
  final String mainLicenseType;
  final String sector;
  final String sectorArabic;
  final String documentsRequired;

  BusinessActivityModel({
    required this.activityMasterNumber,
    required this.isicCode,
    required this.activityName,
    required this.activityNameArabic,
    required this.description,
    required this.descriptionArabic,
    required this.allowedFacilityType,
    required this.allowedSubFacility,
    required this.brandName,
    required this.mainLicenseType,
    required this.sector,
    required this.sectorArabic,
    required this.documentsRequired,
  });

  factory BusinessActivityModel.fromJson(Map<String, dynamic> json) {
    return BusinessActivityModel(
      activityMasterNumber: json['Activity Master Number'] ?? '',
      isicCode: json['ISIC Code'] ?? '',
      activityName: json['Activity Name'] ?? '',
      activityNameArabic: json['Activity Name (Arabic)'] ?? '',
      description: json['Description'] ?? '',
      descriptionArabic: json['Description (Arabic)'] ?? '',
      allowedFacilityType: json['Allowed Facility Type'] ?? '',
      allowedSubFacility: json['Allowed Sub Facility'] ?? '',
      brandName: json['Brand: Brand Name'] ?? '',
      mainLicenseType: json['Main License Type'] ?? '',
      sector: json['Sector'] ?? '',
      sectorArabic: json['Sector Arabic'] ?? '',
      documentsRequired: json['Documents required'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Activity Master Number': activityMasterNumber,
      'ISIC Code': isicCode,
      'Activity Name': activityName,
      'Activity Name (Arabic)': activityNameArabic,
      'Description': description,
      'Description (Arabic)': descriptionArabic,
      'Allowed Facility Type': allowedFacilityType,
      'Allowed Sub Facility': allowedSubFacility,
      'Brand: Brand Name': brandName,
      'Main License Type': mainLicenseType,
      'Sector': sector,
      'Sector Arabic': sectorArabic,
      'Documents required': documentsRequired,
    };
  }

  // Helper method to check if activity is popular based on sector
  bool get isPopular {
    final popularSectors = [
      'Oil and Gas',
      'Chemical',
      'Trading',
      'Technology',
      'Consulting',
      'Real Estate',
    ];
    return popularSectors.any((s) => sector.toLowerCase().contains(s.toLowerCase()));
  }

  // Get icon based on sector
  String get iconName {
    if (sector.toLowerCase().contains('oil') || sector.toLowerCase().contains('gas')) {
      return 'oil_barrel';
    } else if (sector.toLowerCase().contains('technology') || sector.toLowerCase().contains('it')) {
      return 'computer';
    } else if (sector.toLowerCase().contains('trading') || sector.toLowerCase().contains('import')) {
      return 'swap_horiz';
    } else if (sector.toLowerCase().contains('consulting') || sector.toLowerCase().contains('advisory')) {
      return 'business_center';
    } else if (sector.toLowerCase().contains('real estate') || sector.toLowerCase().contains('property')) {
      return 'home_work';
    } else if (sector.toLowerCase().contains('healthcare') || sector.toLowerCase().contains('medical')) {
      return 'local_hospital';
    } else if (sector.toLowerCase().contains('education') || sector.toLowerCase().contains('training')) {
      return 'school';
    } else if (sector.toLowerCase().contains('hospitality') || sector.toLowerCase().contains('tourism')) {
      return 'hotel';
    } else if (sector.toLowerCase().contains('manufacturing') || sector.toLowerCase().contains('industrial')) {
      return 'precision_manufacturing';
    } else if (sector.toLowerCase().contains('finance') || sector.toLowerCase().contains('banking')) {
      return 'account_balance';
    } else {
      return 'business';
    }
  }
}
