import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wazeet_app/features/services/models/service_catalog.dart';
import 'package:wazeet_app/features/services/providers/services_provider.dart';
import 'package:wazeet_app/features/services/repositories/service_catalog_repository.dart';
import 'package:wazeet_app/presentation/controllers/profile_controller.dart';
import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

final _sampleCatalog = [
  const ServiceCategory(
    id: 'business_setup',
    name: 'Business Setup',
    subtitle: 'Company formation & licensing',
    overview: 'Complete support for launching your UAE business.',
    benefits: ['Dedicated consultant'],
    requirements: ['Passport copy'],
    types: [
      ServiceType(
        name: 'LLC Formation',
        description: 'Launch an LLC with guided support',
        subServices: [
          SubService(
            name: 'Standard Package',
            premiumCost: 6500,
            standardCost: 4500,
            premiumTimeline: '5-7 days',
            standardTimeline: '10-12 days',
            documents: 'Passport copy, preferred name reservation',
          ),
        ],
      ),
    ],
  ),
  const ServiceCategory(
    id: 'freezone_packages',
    name: 'Freezone Packages',
    subtitle: 'Tailored packages across UAE freezones',
    overview: 'Choose the best package based on your needs.',
    benefits: ['Multiple licensing options'],
    requirements: ['Passport copy'],
    types: [
      ServiceType(
        name: 'Flexi Desk Package',
        description: 'Perfect for startups needing flexibility',
        subServices: [
          SubService(
            name: 'Starter',
            premiumCost: 5200,
            standardCost: 3800,
            premiumTimeline: '4-5 days',
            standardTimeline: '7-9 days',
            documents: 'Passport copy, residence details',
          ),
        ],
      ),
    ],
  ),
];

Widget _buildTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProfileController()),
      ChangeNotifierProvider(
        create: (_) => ServicesProvider(
          repository: ServiceCatalogRepository(seedCatalog: _sampleCatalog),
        ),
      ),
    ],
    child: const MaterialApp(home: ServicesScreen()),
  );
}

void main() {
  group('ServicesScreen Tests', () {
    testWidgets('renders hero, progress, and category list', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);
      expect(find.text('Business Services'), findsOneWidget);
      expect(
        find.text('Complete business setup solutions in UAE'),
        findsOneWidget,
      );

      expect(find.text('Select Category'), findsOneWidget);
      expect(find.text('Service Categories'), findsOneWidget);
      expect(find.text('Business Setup'), findsOneWidget);
      expect(find.text('Freezone Packages'), findsOneWidget);
    });

    testWidgets('navigates to service types after selecting a category',
        (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Business Setup'));
      await tester.pumpAndSettle();

      expect(find.text('LLC Formation'), findsOneWidget);
      expect(find.text('Company formation & licensing'), findsOneWidget);

      final backButton = find.widgetWithText(OutlinedButton, 'Back');
      expect(backButton, findsOneWidget);

      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      expect(nextButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(nextButton).onPressed, isNull);
    });
  });
}
