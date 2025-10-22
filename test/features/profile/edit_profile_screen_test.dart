import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:wazeet_app/features/profile/data/user_profile.dart';
import 'package:wazeet_app/features/profile/data/user_repository.dart';
import 'package:wazeet_app/features/profile/state/profile_controller.dart';
import 'package:wazeet_app/features/profile/ui/edit_profile_screen.dart';

void main() {
  testWidgets('Save button disabled when name empty and enabled when valid', (tester) async {
    final repository = _FakeUserRepository();
    final controller = ProfileController(repository, listenAuthChanges: false);
    controller.setProfileForTesting(const UserProfile(uid: 'uid-123', email: 'test@example.com'));
    controller.setLoadingForTesting(false);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: controller,
          child: const EditProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final saveButtonFinder = find.widgetWithText(ElevatedButton, 'Save Changes');
    expect(saveButtonFinder, findsOneWidget);
    expect(tester.widget<ElevatedButton>(saveButtonFinder).onPressed, isNull);

    await tester.enterText(find.byType(TextFormField).first, 'Jane Doe');
    await tester.pumpAndSettle();

    expect(tester.widget<ElevatedButton>(saveButtonFinder).onPressed, isNotNull);
  });
}

class _FakeUserRepository implements IUserRepository {
  UserProfile? _profile;

  @override
  User? get currentUser => null;

  @override
  Stream<User?> authChanges() => const Stream<User?>.empty();

  @override
  Future<UserProfile?> getCurrent() async => _profile;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> upsert(UserProfile data) async {
    _profile = data;
  }

  @override
  Future<String> uploadProfileImage(XFile file) async => 'https://example.com/mock.png';

  @override
  Stream<UserProfile?> watchCurrent() => Stream.value(_profile);
}
