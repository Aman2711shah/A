// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:wazeet_app/app.dart';
import 'package:wazeet_app/features/profile/data/user_profile.dart';
import 'package:wazeet_app/features/profile/data/user_repository.dart';
import 'package:wazeet_app/features/profile/state/profile_controller.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<IUserRepository>(create: (_) => _TestUserRepository()),
          ChangeNotifierProvider<ProfileController>(
            create: (context) =>
                ProfileController(context.read<IUserRepository>(), listenAuthChanges: false),
          ),
        ],
        child: const WazeetApp(),
      ),
    );

    // Wait for the splash screen or initial screen to load
    await tester.pumpAndSettle();

    // Verify that the app loads without crashing
    expect(find.byType(WazeetApp), findsOneWidget);
  });
}

class _TestUserRepository implements IUserRepository {
  @override
  Stream<User?> authChanges() => const Stream<User?>.empty();

  @override
  User? get currentUser => null;

  @override
  Future<UserProfile?> getCurrent() async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> upsert(UserProfile data) async {}

  @override
  Future<String> uploadProfileImage(XFile file) async => '';

  @override
  Stream<UserProfile?> watchCurrent() => const Stream<UserProfile?>.empty();
}
