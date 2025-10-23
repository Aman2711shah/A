import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/service_catalog_fallback.dart';
import '../models/service_catalog.dart';

class ServiceCatalogRepository {
  ServiceCatalogRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore;
  // Defer Firebase initialization to method calls so tests can run without a Firebase app.
  final FirebaseFirestore? _firestore;

  Future<List<ServiceCategory>> fetchCatalog() async {
    try {
      final firestore = _firestore ?? FirebaseFirestore.instance;
      final categoriesSnapshot =
          await firestore.collection('service_categories').get();
      if (categoriesSnapshot.docs.isEmpty) {
        return fallbackServiceCatalog;
      }

      final List<ServiceCategory> categories = [];
      for (final doc in categoriesSnapshot.docs) {
        final typesSnapshot = await doc.reference.collection('types').get();
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
    Map<String, String>? documentUrls,
  }) async {
    final firestore = _firestore ?? FirebaseFirestore.instance;
    await firestore.collection('service_quotes').add({
      ...customerData,
      'categoryId': category.id,
      'categoryName': category.name,
      'serviceType': type.name,
      'subService': subService.name,
      'documents': documentUrls ?? const <String, String>{},
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }
}
