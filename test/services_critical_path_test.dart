import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:wazeet_app/features/services/providers/services_provider.dart';
import 'package:wazeet_app/features/services/repositories/service_catalog_repository.dart';
import 'package:wazeet_app/features/services/models/service_catalog.dart';
import 'package:wazeet_app/features/services/data/service_catalog_fallback.dart';
import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

class _FakeServiceCatalogRepository extends ServiceCatalogRepository {
  _FakeServiceCatalogRepository() : super(firestore: null);

  @override
  Future<List<ServiceCategory>> fetchCatalog() async {
    // Use the provided fallback data to avoid hitting Firebase in tests
    return fallbackServiceCatalog;
  }

  @override
  Future<void> submitQuoteRequest({
    required ServiceCategory category,
    required ServiceType type,
    required SubService subService,
    required Map<String, dynamic> customerData,
    Map<String, String>? documentUrls,
  }) async {
    // No-op for tests
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // Ignore if already initialized or not required in this environment.
    }
  });

  testWidgets(
      'Services critical path: category -> type -> sub-service -> review with form',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => ServicesProvider(
            repository: _FakeServiceCatalogRepository(),
          ),
          child: const ServicesScreen(),
        ),
      ),
    );

    // Allow initial async loads and frame building.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    // Step 1: Select a Category (from fallback data).
    // Expect at least "Company Setup" category to be present.
    expect(find.text('Service Categories'), findsOneWidget);
    expect(find.text('Company Setup'), findsWidgets);
    await tester.tap(find.text('Company Setup').first);
    await tester.pumpAndSettle();

    // Step 2: Select a Service Type (from fallback data).
    // Expect "Mainland Company" type to be present.
    expect(find.text('Mainland Company'), findsWidgets);
    await tester.tap(find.text('Mainland Company').first);
    await tester.pumpAndSettle();

    // Step 3: Select a Sub-Service (from fallback data).
    // Expect "LLC Formation" sub-service to be present.
    expect(find.text('LLC Formation'), findsWidgets);
    await tester.tap(find.text('LLC Formation').first);
    await tester.pumpAndSettle();

    // Review step assertions:
    // - Cost estimate card
    expect(find.text('Cost Estimate'), findsOneWidget);

    // - Documents Required section (parsed from subService.documents)
    expect(find.text('Documents Required'), findsOneWidget);

    // - Quote form primary action
    expect(find.text('Submit Quote Request'), findsOneWidget);

    // - Start application CTA still available
    expect(find.text('Start Application'), findsOneWidget);
  });
}
