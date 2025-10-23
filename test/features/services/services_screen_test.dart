import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wazeet_app/presentation/screens/home/home_screen.dart';
import 'package:wazeet_app/presentation/controllers/profile_controller.dart';

void main() {
  group('ServicesScreen Tests', () {
    testWidgets('Renders services screen with category list', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ProfileController(),
          child: const MaterialApp(
            home: ServicesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);

      // Verify hero section
      expect(find.text('Professional Business Services'), findsOneWidget);

      // Verify progress indicator (step 0)
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // Verify initial step shows categories
      expect(find.text('Select Service Category'), findsOneWidget);

      // Should show service categories
      expect(find.text('Business Setup'), findsOneWidget);
      expect(find.text('Freezone Packages'), findsOneWidget);
      expect(find.text('Growth Services'), findsOneWidget);
    });

    testWidgets('Can select a service category', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ProfileController(),
          child: const MaterialApp(
            home: ServicesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap "Business Setup" category
      final businessSetupCard = find
          .ancestor(
            of: find.text('Business Setup'),
            matching: find.byType(Card),
          )
          .first;

      await tester.tap(businessSetupCard);
      await tester.pumpAndSettle();

      // After selection, "Next" button should be enabled
      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      expect(nextButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(nextButton).onPressed, isNotNull);
    });
  });
}
