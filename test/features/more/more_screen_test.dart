import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

void main() {
  group('MoreScreen Tests', () {
    testWidgets('Renders more screen with basic structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MoreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets('Shows profile section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MoreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify profile section exists
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Shows menu options', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MoreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify menu options exist
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Menu options are scrollable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MoreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to see all options
      final scrollable = find.byType(SingleChildScrollView);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -300));
        await tester.pumpAndSettle();
      }

      // Should have menu items - looking for common text
      final widgets = find.byType(Card);
      expect(widgets, findsWidgets);
    });

    testWidgets('Screen is scrollable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MoreScreen(),
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

    testWidgets('Has list tiles for navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MoreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Should have list tiles for menu options
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Shows icons for menu items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MoreScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Should have icons
      expect(find.byType(Icon), findsWidgets);
    });
  });
}
