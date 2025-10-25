import 'package:cloud_firestore/cloud_firestore.dart';

class TradeLicenseApplication {
  final String? id;
  final String userId;
  final String companyName;
  final String tradeName;
  final String licenseType;
  final String businessActivity;
  final List<String> activities;
  final String emirate;
  final String status;
  final DateTime submittedAt;
  final DateTime? estimatedCompletion;
  final DateTime? completedAt;
  final Map<String, dynamic>? documents;
  final String? rejectionReason;
  final Map<String, dynamic>? metadata;

  TradeLicenseApplication({
    this.id,
    required this.userId,
    required this.companyName,
    required this.tradeName,
    required this.licenseType,
    required this.businessActivity,
    this.activities = const [],
    required this.emirate,
    this.status = 'draft',
    required this.submittedAt,
    this.estimatedCompletion,
    this.completedAt,
    this.documents,
    this.rejectionReason,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'companyName': companyName,
      'tradeName': tradeName,
      'licenseType': licenseType,
      'businessActivity': businessActivity,
      'activities': activities,
      'emirate': emirate,
      'status': status,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'estimatedCompletion': estimatedCompletion != null ? Timestamp.fromDate(estimatedCompletion!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'documents': documents,
      'rejectionReason': rejectionReason,
      'metadata': metadata,
    };
  }

  factory TradeLicenseApplication.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TradeLicenseApplication(
      id: doc.id,
      userId: data['userId'] as String,
      companyName: data['companyName'] as String,
      tradeName: data['tradeName'] as String,
      licenseType: data['licenseType'] as String,
      businessActivity: data['businessActivity'] as String,
      activities: List<String>.from(data['activities'] ?? []),
      emirate: data['emirate'] as String,
      status: data['status'] as String? ?? 'draft',
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
      estimatedCompletion: data['estimatedCompletion'] != null ? (data['estimatedCompletion'] as Timestamp).toDate() : null,
      completedAt: data['completedAt'] != null ? (data['completedAt'] as Timestamp).toDate() : null,
      documents: data['documents'] as Map<String, dynamic>?,
      rejectionReason: data['rejectionReason'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }
}
