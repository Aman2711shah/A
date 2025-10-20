import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company_setup_model.g.dart';

@JsonSerializable()
class CompanySetupModel extends Equatable {
  final String id;
  final String userId;
  final int currentStep;
  final List<BusinessActivity> activities;
  final List<Shareholder> shareholders;
  final VisaRequirements visaRequirements;
  final int licenseTenure;
  final String entityType;
  final String? recommendedFreeZone;
  final double estimatedCost;
  final String status;
  final DateTime lastUpdated;

  const CompanySetupModel({
    required this.id,
    required this.userId,
    required this.currentStep,
    required this.activities,
    required this.shareholders,
    required this.visaRequirements,
    required this.licenseTenure,
    required this.entityType,
    this.recommendedFreeZone,
    required this.estimatedCost,
    required this.status,
    required this.lastUpdated,
  });

  factory CompanySetupModel.fromJson(Map<String, dynamic> json) =>
      _$CompanySetupModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanySetupModelToJson(this);

  CompanySetupModel copyWith({
    String? id,
    String? userId,
    int? currentStep,
    List<BusinessActivity>? activities,
    List<Shareholder>? shareholders,
    VisaRequirements? visaRequirements,
    int? licenseTenure,
    String? entityType,
    String? recommendedFreeZone,
    double? estimatedCost,
    String? status,
    DateTime? lastUpdated,
  }) {
    return CompanySetupModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStep: currentStep ?? this.currentStep,
      activities: activities ?? this.activities,
      shareholders: shareholders ?? this.shareholders,
      visaRequirements: visaRequirements ?? this.visaRequirements,
      licenseTenure: licenseTenure ?? this.licenseTenure,
      entityType: entityType ?? this.entityType,
      recommendedFreeZone: recommendedFreeZone ?? this.recommendedFreeZone,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        currentStep,
        activities,
        shareholders,
        visaRequirements,
        licenseTenure,
        entityType,
        recommendedFreeZone,
        estimatedCost,
        status,
        lastUpdated,
      ];
}

@JsonSerializable()
class BusinessActivity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String licenseRequired;

  const BusinessActivity({
    required this.id,
    required this.name,
    required this.category,
    required this.licenseRequired,
  });

  factory BusinessActivity.fromJson(Map<String, dynamic> json) =>
      _$BusinessActivityFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessActivityToJson(this);

  @override
  List<Object?> get props => [id, name, category, licenseRequired];
}

@JsonSerializable()
class Shareholder extends Equatable {
  final String id;
  final String name;
  final String type;
  final double ownershipPercentage;
  final String nationality;
  final List<String> documentIds;

  const Shareholder({
    required this.id,
    required this.name,
    required this.type,
    required this.ownershipPercentage,
    required this.nationality,
    required this.documentIds,
  });

  factory Shareholder.fromJson(Map<String, dynamic> json) =>
      _$ShareholderFromJson(json);
  Map<String, dynamic> toJson() => _$ShareholderToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        ownershipPercentage,
        nationality,
        documentIds,
      ];
}

@JsonSerializable()
class VisaRequirements extends Equatable {
  final int employmentVisaCount;
  final int investorVisaCount;
  final bool includeDependent;

  const VisaRequirements({
    required this.employmentVisaCount,
    required this.investorVisaCount,
    this.includeDependent = false,
  });

  factory VisaRequirements.fromJson(Map<String, dynamic> json) =>
      _$VisaRequirementsFromJson(json);
  Map<String, dynamic> toJson() => _$VisaRequirementsToJson(this);

  @override
  List<Object?> get props => [
        employmentVisaCount,
        investorVisaCount,
        includeDependent,
      ];
}