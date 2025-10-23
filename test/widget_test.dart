import 'package:flutter_test/flutter_test.dart';
import 'package:wazeet_app/app.dart';

void main() {
  testWidgets('App smoke test: renders splash with WAZEET branding',
      (tester) async {
    await tester.pumpWidget(const WazeetApp());
    // Allow first frame
    await tester.pump();
    // Splash shows the branding text
    expect(find.text('WAZEET'), findsOneWidget);
  });
}
