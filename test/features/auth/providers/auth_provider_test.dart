import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wazeet_app/core/services/storage_service.dart';
import 'package:wazeet_app/features/auth/providers/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('auth_provider_test');
    Hive.init(tempDir.path);
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  tearDown(() async {
    await StorageService.clearAll();
    await StorageService.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('login stores user data and token', () async {
    final provider = AuthProvider();
    await Future<void>.delayed(Duration.zero);

    expect(provider.isAuthenticated, isFalse);

    await provider.login('user@demo.com', 'password123');

    expect(provider.isAuthenticated, isTrue);
    expect(provider.userToken, isNotEmpty);
    expect(provider.userData?['email'], 'user@demo.com');
    expect(provider.isLoading, isFalse);
  });

  test('logout clears stored auth state', () async {
    final provider = AuthProvider();
    await Future<void>.delayed(Duration.zero);

    await provider.login('user@demo.com', 'password123');
    await provider.logout();

    expect(provider.isAuthenticated, isFalse);
    expect(provider.userToken, isNull);
    expect(provider.userData, isNull);
  });
}
