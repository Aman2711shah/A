import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

void main() {
  group('ServicesScreen Tests', () {
    testWidgets('Renders services screen with category list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServicesScreen(),
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
        const MaterialApp(
          home: ServicesScreen(),
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

    testWidgets('Navigation through service flow steps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServicesScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Step 0: Select category
      final categoryCard = find
          .ancestor(
            of: find.text('Business Setup'),
            matching: find.byType(Card),
          )
          .first;
      await tester.tap(categoryCard);
      await tester.pumpAndSettle();

      // Tap Next to move to step 1
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // Step 1: Should show service types
      expect(find.text('Select Service Type'), findsOneWidget);

      // Should be able to go back
      final backButton = find.widgetWithText(TextButton, 'Back');
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Should be back at category selection
      expect(find.text('Select Service Category'), findsOneWidget);
    });

    testWidgets('Next button disabled when no selection made', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServicesScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Initially, Next button should be disabled
      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      expect(nextButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(nextButton).onPressed, isNull);
    });

    testWidgets('Shows all service categories with descriptions',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServicesScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll through the list to verify all categories
      final scrollable = find.byType(SingleChildScrollView);

      // Verify some key categories
      expect(find.text('Business Setup'), findsOneWidget);
      expect(find.text('Freezone Packages'), findsOneWidget);

      // Scroll down to see more
      await tester.drag(scrollable, const Offset(0, -500));
      await tester.pumpAndSettle();

      // Check for more categories
      expect(find.text('Growth Services'), findsOneWidget);
    });

    testWidgets('Progress bar updates based on step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServicesScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Initial progress
      LinearProgressIndicator progressBar =
          tester.widget(find.byType(LinearProgressIndicator));
      expect(progressBar.value, equals(0.25));

      // Select category and move to next step
      final categoryCard = find
          .ancestor(
            of: find.text('Business Setup'),
            matching: find.byType(Card),
          )
          .first;
      await tester.tap(categoryCard);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // Progress should increase
      progressBar = tester.widget(find.byType(LinearProgressIndicator));
      expect(progressBar.value, equals(0.5));
    });
  });
}
