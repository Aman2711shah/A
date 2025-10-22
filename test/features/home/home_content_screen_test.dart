import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

void main() {
  group('HomeContentScreen Tests', () {
    testWidgets('Renders dashboard with stats cards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeContentScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('WAZEET'), findsOneWidget);

      // Verify welcome banner
      expect(find.text('Welcome to WAZEET'), findsOneWidget);
      expect(find.text('Your trusted partner for business setup in UAE'),
          findsOneWidget);

      // Verify stats cards exist
      expect(find.text('Active Applications'), findsOneWidget);
      expect(find.text('Companies'), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);

      // Verify quick actions section
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('New Company'), findsOneWidget);
      expect(find.text('Track Application'), findsOneWidget);
    });

    testWidgets('Quick action buttons are tappable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeContentScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap "New Company" button
      final newCompanyButton = find.widgetWithText(Card, 'New Company');
      expect(newCompanyButton, findsOneWidget);

      await tester.tap(newCompanyButton);
      await tester.pumpAndSettle();

      // The tap should work without errors
    });

    testWidgets('Recent activity section displays', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeContentScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify recent activity section
      expect(find.text('Recent Activity'), findsOneWidget);

      // Scroll to find the activity section if needed
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
    });

    testWidgets('Shows placeholder when no data available', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeContentScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Since this is a placeholder, stats should show "0"
      expect(find.text('0'), findsWidgets);
    });
  });
}
