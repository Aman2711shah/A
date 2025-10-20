import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class PackageModel extends Equatable {
  final String id;
  final String name;
  final String freeZone;
  final double price;
  final int visaCount;
  final int validityYears;
  final String processingDays;
  final List<String> features;
  final bool isRecommended;

  const PackageModel({
    required this.id,
    required this.name,
    required this.freeZone,
    required this.price,
    required this.visaCount,
    required this.validityYears,
    required this.processingDays,
    required this.features,
    this.isRecommended = false,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => _$PackageModelFromJson(json);
  Map<String, dynamic> toJson() => _$PackageModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        freeZone,
        price,
        visaCount,
        validityYears,
        processingDays,
        features,
        isRecommended,
      ];
}