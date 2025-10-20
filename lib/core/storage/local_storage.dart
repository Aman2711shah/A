import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/company_setup_model.dart';

class LocalStorage {
  static const String _companySetupBox = 'company_setup_drafts';
  static const String _settingsBox = 'app_settings';

  // Initialize Hive boxes
  Future<void> init() async {
    await Hive.openBox<Map>(_companySetupBox);
    await Hive.openBox(_settingsBox);
  }

  // Company Setup Drafts
  Future<void> saveDraft(String userId, CompanySetupModel setup) async {
    final box = Hive.box<Map>(_companySetupBox);
    await box.put(userId, setup.toJson());
  }

  CompanySetupModel? getDraft(String userId) {
    final box = Hive.box<Map>(_companySetupBox);
    final data = box.get(userId);
    if (data == null) return null;
    return CompanySetupModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> deleteDraft(String userId) async {
    final box = Hive.box<Map>(_companySetupBox);
    await box.delete(userId);
  }

  // App Settings
  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }

  // Onboarding
  Future<void> setOnboardingComplete(bool value) async {
    await saveSetting('onboarding_complete', value);
  }

  bool isOnboardingComplete() {
    return getSetting('onboarding_complete', defaultValue: false);
  }

  // Theme
  Future<void> setThemeMode(String mode) async {
    await saveSetting('theme_mode', mode);
  }

  String getThemeMode() {
    return getSetting('theme_mode', defaultValue: 'system');
  }
}