import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/service_catalog_fallback.dart';
import '../models/service_catalog.dart';

class ServiceCatalogRepository {
  ServiceCatalogRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  Future<List<ServiceCategory>> fetchCatalog() async {
    try {
      final categoriesSnapshot =
          await _firestore.collection('service_categories').get();
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
    await _firestore.collection('service_quotes').add({
      ...customerData,
      'categoryId': category.id,
      'categoryName': category.name,
      'serviceType': type.name,
      'subService': subService.name,
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }
}
