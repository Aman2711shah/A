import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/service_catalog_fallback.dart';
import '../models/service_catalog.dart';

class ServiceCatalogRepository {
  ServiceCatalogRepository({
    FirebaseFirestore? firestore,
    List<ServiceCategory>? seedCatalog,
  })  : _firestore = firestore,
        _seedCatalog = seedCatalog;

  final FirebaseFirestore? _firestore;
  final List<ServiceCategory>? _seedCatalog;

  Future<List<ServiceCategory>> fetchCatalog() async {
    if (_seedCatalog != null) {
      return _seedCatalog!;
    }

    try {
      final firestore = _firestore ?? FirebaseFirestore.instance;
      final categoriesSnapshot =
          await firestore.collection('service_categories').get();
      if (categoriesSnapshot.docs.isEmpty) {
        return fallbackServiceCatalog;
      }

      final List<ServiceCategory> categories = [];
      for (final doc in categoriesSnapshot.docs) {
        final typesSnapshot =
            await doc.reference.collection('types').get();
        final types = typesSnapshot.docs
            .map((typeDoc) => ServiceType.fromDoc(typeDoc))
            .toList();
        categories.add(ServiceCategory.fromDoc(
          doc,
          types: types,
        ));
      }
      return categories;
    } catch (e) {
      return fallbackServiceCatalog;
    }
  }

  Future<void> submitQuoteRequest({
    required ServiceCategory category,
    required ServiceType type,
    required SubService subService,
    required Map<String, dynamic> customerData,
  }) async {
    final firestore = _firestore ?? FirebaseFirestore.instance;
    await firestore.collection('service_quotes').add({
      ...customerData,
      'categoryId': category.id,
      'categoryName': category.name,
      'serviceType': type.name,
      'subService': subService.name,
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }
}
