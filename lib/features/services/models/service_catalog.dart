import 'package:cloud_firestore/cloud_firestore.dart';

class SubService {
  const SubService({
    required this.name,
    required this.premiumCost,
    required this.standardCost,
    required this.premiumTimeline,
    required this.standardTimeline,
    required this.documents,
  });

  final String name;
  final num premiumCost;
  final num standardCost;
  final String premiumTimeline;
  final String standardTimeline;
  final String documents;

  factory SubService.fromMap(Map<String, dynamic> map) {
    return SubService(
      name: map['name'] as String? ?? '',
      premiumCost: map['premiumCost'] ?? 0,
      standardCost: map['standardCost'] ?? 0,
      premiumTimeline: map['premiumTimeline'] as String? ?? 'N/A',
      standardTimeline: map['standardTimeline'] as String? ?? 'N/A',
      documents: map['documents'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'premiumCost': premiumCost,
      'standardCost': standardCost,
      'premiumTimeline': premiumTimeline,
      'standardTimeline': standardTimeline,
      'documents': documents,
    };
  }
}

class ServiceType {
  const ServiceType({
    required this.name,
    this.description,
    required this.subServices,
  });

  final String name;
  final String? description;
  final List<SubService> subServices;

  factory ServiceType.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final subServices = (data['subServices'] as List? ?? const [])
        .map((e) =>
            SubService.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
    return ServiceType(
      name: data['name'] as String? ?? '',
      description: data['description'] as String?,
      subServices: subServices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (description != null) 'description': description,
      'subServices': subServices.map((e) => e.toMap()).toList(),
    };
  }
}

class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.overview,
    required this.benefits,
    required this.requirements,
    required this.types,
  });

  final String id;
  final String name;
  final String subtitle;
  final String overview;
  final List<String> benefits;
  final List<String> requirements;
  final List<ServiceType> types;

  bool get hasTypes => types.isNotEmpty;

  factory ServiceCategory.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    List<ServiceType> types = const [],
  }) {
    final data = doc.data() ?? <String, dynamic>{};
    return ServiceCategory(
      id: doc.id,
      name: data['name'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      overview: data['overview'] as String? ?? '',
      benefits:
          (data['benefits'] as List?)?.cast<String>() ?? const <String>[],
      requirements: (data['requirements'] as List?)
              ?.cast<String>() ??
          const <String>[],
      types: types,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subtitle': subtitle,
      'overview': overview,
      'benefits': benefits,
      'requirements': requirements,
      'types': types.map((e) => e.toMap()).toList(),
    };
  }
}
