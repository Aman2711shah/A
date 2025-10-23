import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
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

      // Find and tap the 'New Company' button
      final newCompanyButton = find.text('New Company');
      expect(newCompanyButton, findsOneWidget);
      await tester.tap(newCompanyButton);
      await tester.pumpAndSettle();

      // Find and tap the 'Track Application' button
      final trackAppButton = find.text('Track Application');
      expect(trackAppButton, findsOneWidget);
      await tester.tap(trackAppButton);
      await tester.pumpAndSettle();
    });

    testWidgets('Stats cards display correct information', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeContentScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all three stat cards are present
      expect(find.text('Active Applications'), findsOneWidget);
      expect(find.text('Companies'), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);

      // Verify stat values are displayed (these might be '0' initially)
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('Welcome banner is visible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeContentScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify welcome text
      expect(find.text('Welcome to WAZEET'), findsOneWidget);
      expect(find.text('Your trusted partner for business setup in UAE'),
          findsOneWidget);
    });
  });
}
