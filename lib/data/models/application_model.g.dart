// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    ApplicationModel(
      id: json['id'] as String,
      applicationNumber: json['applicationNumber'] as String,
      userId: json['userId'] as String,
      jurisdiction: json['jurisdiction'] as String,
      emirateFreeZone: json['emirateFreeZone'] as String,
      packageId: json['packageId'] as String,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      documents: (json['documents'] as List<dynamic>)
          .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      contactDetails: json['contactDetails'] as Map<String, dynamic>,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
    );

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'applicationNumber': instance.applicationNumber,
      'userId': instance.userId,
      'jurisdiction': instance.jurisdiction,
      'emirateFreeZone': instance.emirateFreeZone,
      'packageId': instance.packageId,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'documents': instance.documents,
      'contactDetails': instance.contactDetails,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'approvedAt': instance.approvedAt?.toIso8601String(),
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.draft: 'draft',
  ApplicationStatus.submitted: 'submitted',
  ApplicationStatus.underReview: 'underReview',
  ApplicationStatus.documentsRequested: 'documentsRequested',
  ApplicationStatus.approved: 'approved',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.completed: 'completed',
};

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      id: json['id'] as String,
      type: json['type'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String?,
      fileSize: (json['fileSize'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      uploadStatus: json['uploadStatus'] as String,
      uploadedAt: json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'uploadStatus': instance.uploadStatus,
      'uploadedAt': instance.uploadedAt?.toIso8601String(),
    };

