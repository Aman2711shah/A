// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_setup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanySetupModel _$CompanySetupModelFromJson(Map<String, dynamic> json) =>
    CompanySetupModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      currentStep: (json['currentStep'] as num).toInt(),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => BusinessActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      shareholders: (json['shareholders'] as List<dynamic>)
          .map((e) => Shareholder.fromJson(e as Map<String, dynamic>))
          .toList(),
      visaRequirements: VisaRequirements.fromJson(
          json['visaRequirements'] as Map<String, dynamic>),
      licenseTenure: (json['licenseTenure'] as num).toInt(),
      entityType: json['entityType'] as String,
      recommendedFreeZone: json['recommendedFreeZone'] as String?,
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      status: json['status'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$CompanySetupModelToJson(CompanySetupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'currentStep': instance.currentStep,
      'activities': instance.activities,
      'shareholders': instance.shareholders,
      'visaRequirements': instance.visaRequirements,
      'licenseTenure': instance.licenseTenure,
      'entityType': instance.entityType,
      'recommendedFreeZone': instance.recommendedFreeZone,
      'estimatedCost': instance.estimatedCost,
      'status': instance.status,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

BusinessActivity _$BusinessActivityFromJson(Map<String, dynamic> json) =>
    BusinessActivity(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      licenseRequired: json['licenseRequired'] as String,
    );

Map<String, dynamic> _$BusinessActivityToJson(BusinessActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'licenseRequired': instance.licenseRequired,
    };

Shareholder _$ShareholderFromJson(Map<String, dynamic> json) => Shareholder(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      ownershipPercentage: (json['ownershipPercentage'] as num).toDouble(),
      nationality: json['nationality'] as String,
      documentIds: (json['documentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ShareholderToJson(Shareholder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'ownershipPercentage': instance.ownershipPercentage,
      'nationality': instance.nationality,
      'documentIds': instance.documentIds,
    };

VisaRequirements _$VisaRequirementsFromJson(Map<String, dynamic> json) =>
    VisaRequirements(
      employmentVisaCount: (json['employmentVisaCount'] as num).toInt(),
      investorVisaCount: (json['investorVisaCount'] as num).toInt(),
      includeDependent: json['includeDependent'] as bool? ?? false,
    );

Map<String, dynamic> _$VisaRequirementsToJson(VisaRequirements instance) =>
    <String, dynamic>{
      'employmentVisaCount': instance.employmentVisaCount,
      'investorVisaCount': instance.investorVisaCount,
      'includeDependent': instance.includeDependent,
    };

