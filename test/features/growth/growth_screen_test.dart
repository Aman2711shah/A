import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

void main() {
  group('GrowthScreen Tests', () {
    testWidgets('Renders growth screen with service redirect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GrowthScreen(
            onNavigateToServices: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Growth'), findsOneWidget);

      // Verify redirect card content
      expect(find.text('Business Growth Services'), findsOneWidget);
      expect(find.textContaining('moved to'), findsOneWidget);
    });

    testWidgets('Navigate to Services tab when card tapped', (tester) async {
      bool navigatedToServices = false;

      await tester.pumpWidget(
        MaterialApp(
          home: GrowthScreen(
            onNavigateToServices: () {
              navigatedToServices = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the redirect card
      final redirectCard =
          find.widgetWithText(Card, 'Business Growth Services');
      expect(redirectCard, findsOneWidget);

      // Tap the card
      await tester.tap(redirectCard);
      await tester.pumpAndSettle();

      // Verify callback was triggered
      expect(navigatedToServices, isTrue);
    });

    testWidgets('Shows services icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GrowthScreen(
            onNavigateToServices: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have business/services related icon
      expect(find.byIcon(Icons.business_center), findsOneWidget);
    });

    testWidgets('Displays arrow icon indicating navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GrowthScreen(
            onNavigateToServices: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have arrow icon for navigation
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('Card is tappable with InkWell effect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GrowthScreen(
            onNavigateToServices: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have InkWell for tap feedback
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
