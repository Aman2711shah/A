import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

void main() {
  group('CommunityScreen Tests', () {
    testWidgets('Renders community screen with placeholder content',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommunityScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Community'), findsOneWidget);

      // Verify main content
      expect(find.text('Entrepreneur Community'), findsOneWidget);
      expect(find.text('Connect with other business owners'), findsOneWidget);
    });

    testWidgets('Shows community features section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommunityScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify community features are displayed
      expect(find.text('Forums'), findsOneWidget);
      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Networking'), findsOneWidget);
    });

    testWidgets('Displays coming soon indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommunityScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Community is a placeholder, should indicate coming soon
      expect(find.textContaining('Coming'), findsWidgets);
    });

    testWidgets('Shows network icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommunityScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Should have community/network related icons
      expect(find.byIcon(Icons.people), findsWidgets);
    });

    testWidgets('Screen is scrollable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommunityScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Should have scrollable content
      final scrollable = find.byType(SingleChildScrollView);
      expect(scrollable, findsOneWidget);

      // Should be able to scroll
      await tester.drag(scrollable, const Offset(0, -100));
      await tester.pumpAndSettle();
    });
  });
}
