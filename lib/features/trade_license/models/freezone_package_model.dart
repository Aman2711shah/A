class FreezonePackageModel {
  final String freezoneName;
  final String packageName;
  final String activitiesAllowed;
  final String shareholdersAllowed;
  final int visasIncluded;
  final int tenureYears;
  final double priceAED;
  final double immigrationCardFee;
  final double eChannelFee;
  final double visaCostAED;
  final double medicalFee;
  final double emiratesIdFee;
  final double changeOfStatusFee;
  final String? otherNotes;

  const FreezonePackageModel({
    required this.freezoneName,
    required this.packageName,
    required this.activitiesAllowed,
    required this.shareholdersAllowed,
    required this.visasIncluded,
    required this.tenureYears,
    required this.priceAED,
    required this.immigrationCardFee,
    required this.eChannelFee,
    required this.visaCostAED,
    required this.medicalFee,
    required this.emiratesIdFee,
    required this.changeOfStatusFee,
    this.otherNotes,
  });

  factory FreezonePackageModel.fromJson(Map<String, dynamic> json) {
    return FreezonePackageModel(
      freezoneName: json['Freezone'] as String? ?? '',
      packageName: json['Package Name'] as String? ?? '',
      activitiesAllowed: json['No. of Activities Allowed'] as String? ?? '',
      shareholdersAllowed: json['No. of Shareholders Allowed'] as String? ?? '',
      visasIncluded: _parseInt(json['No. of Visas Included']),
      tenureYears: _parseInt(json['Tenure (Years)']),
      priceAED: _parseDouble(json['Price (AED)']),
      immigrationCardFee: _parseDouble(json['Immigration Card Fee']),
      eChannelFee: _parseDouble(json['E-Channel Fee']),
      visaCostAED: _parseDouble(json['Visa Cost (AED)']),
      medicalFee: _parseDouble(json['Medical Fee']),
      emiratesIdFee: _parseDouble(json['Emirates ID Fee']),
      changeOfStatusFee: _parseDouble(json['Change of Status Fee']),
      otherNotes: json['Other Costs / Notes'] as String?,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
      final doubleParsed = double.tryParse(value);
      if (doubleParsed != null) return doubleParsed.toInt();
    }
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    return 0.0;
  }

  double get totalCostWithVisa {
    return priceAED +
        immigrationCardFee +
        eChannelFee +
        visaCostAED +
        medicalFee +
        emiratesIdFee +
        changeOfStatusFee;
  }

  double get totalCostWithoutVisa {
    return priceAED;
  }

  String get displayTenure {
    return tenureYears == 1 ? '1 Year' : '$tenureYears Years';
  }

  Map<String, dynamic> toJson() {
    return {
      'Freezone': freezoneName,
      'Package Name': packageName,
      'No. of Activities Allowed': activitiesAllowed,
      'No. of Shareholders Allowed': shareholdersAllowed,
      'No. of Visas Included': visasIncluded,
      'Tenure (Years)': tenureYears,
      'Price (AED)': priceAED,
      'Immigration Card Fee': immigrationCardFee,
      'E-Channel Fee': eChannelFee,
      'Visa Cost (AED)': visaCostAED,
      'Medical Fee': medicalFee,
      'Emirates ID Fee': emiratesIdFee,
      'Change of Status Fee': changeOfStatusFee,
      'Other Costs / Notes': otherNotes,
    };
  }
}
