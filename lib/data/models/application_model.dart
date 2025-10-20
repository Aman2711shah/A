import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_model.g.dart';

enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  documentsRequested,
  approved,
  rejected,
  completed
}

@JsonSerializable()
class ApplicationModel extends Equatable {
  final String id;
  final String applicationNumber;
  final String userId;
  final String jurisdiction;
  final String emirateFreeZone;
  final String packageId;
  final ApplicationStatus status;
  final List<DocumentModel> documents;
  final Map<String, dynamic> contactDetails;
  final DateTime submittedAt;
  final DateTime? approvedAt;

  const ApplicationModel({
    required this.id,
    required this.applicationNumber,
    required this.userId,
    required this.jurisdiction,
    required this.emirateFreeZone,
    required this.packageId,
    required this.status,
    required this.documents,
    required this.contactDetails,
    required this.submittedAt,
    this.approvedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        applicationNumber,
        userId,
        jurisdiction,
        emirateFreeZone,
        packageId,
        status,
        documents,
        contactDetails,
        submittedAt,
        approvedAt,
      ];
}

@JsonSerializable()
class DocumentModel extends Equatable {
  final String id;
  final String type;
  final String fileName;
  final String? fileUrl;
  final int fileSize;
  final String mimeType;
  final String uploadStatus;
  final DateTime? uploadedAt;

  const DocumentModel({
    required this.id,
    required this.type,
    required this.fileName,
    this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.uploadStatus,
    this.uploadedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => _$DocumentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        type,
        fileName,
        fileUrl,
        fileSize,
        mimeType,
        uploadStatus,
        uploadedAt,
      ];
}