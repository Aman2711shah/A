// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageModel _$PackageModelFromJson(Map<String, dynamic> json) => PackageModel(
      id: json['id'] as String,
      name: json['name'] as String,
      freeZone: json['freeZone'] as String,
      price: (json['price'] as num).toDouble(),
      visaCount: (json['visaCount'] as num).toInt(),
      validityYears: (json['validityYears'] as num).toInt(),
      processingDays: json['processingDays'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      isRecommended: json['isRecommended'] as bool? ?? false,
    );

Map<String, dynamic> _$PackageModelToJson(PackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'freeZone': instance.freeZone,
      'price': instance.price,
      'visaCount': instance.visaCount,
      'validityYears': instance.validityYears,
      'processingDays': instance.processingDays,
      'features': instance.features,
      'isRecommended': instance.isRecommended,
    };

