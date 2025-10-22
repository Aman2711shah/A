import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service to persist company setup wizard progress
class WizardPersistenceService {
  static const String _keyPrefix = 'company_setup_wizard_';
  static const String _currentStepKey = 'current_step';
  static const String _formDataKey = 'form_data';
  static const String _timestampKey = 'last_saved';

  /// Save wizard progress
  static Future<void> saveProgress({
    required String userId,
    required int currentStep,
    required Map<String, dynamic> formData,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _keyPrefix + userId;

      final data = {
        _currentStepKey: currentStep,
        _formDataKey: formData,
        _timestampKey: DateTime.now().toIso8601String(),
      };

      await prefs.setString(key, json.encode(data));
    } catch (e) {
      print('Error saving wizard progress: $e');
    }
  }

  /// Load wizard progress
  static Future<Map<String, dynamic>?> loadProgress(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _keyPrefix + userId;

      final dataString = prefs.getString(key);
      if (dataString == null) return null;

      final data = json.decode(dataString) as Map<String, dynamic>;
      
      // Check if progress is too old (older than 30 days)
      final timestamp = DateTime.parse(data[_timestampKey] as String);
      final age = DateTime.now().difference(timestamp).inDays;
      
      if (age > 30) {
        // Clear old progress
        await clearProgress(userId);
        return null;
      }

      return data;
    } catch (e) {
      print('Error loading wizard progress: $e');
      return null;
    }
  }

  /// Clear wizard progress
  static Future<void> clearProgress(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _keyPrefix + userId;
      await prefs.remove(key);
    } catch (e) {
      print('Error clearing wizard progress: $e');
    }
  }

  /// Check if user has saved progress
  static Future<bool> hasSavedProgress(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _keyPrefix + userId;
      return prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Get last saved timestamp
  static Future<DateTime?> getLastSavedTimestamp(String userId) async {
    try {
      final data = await loadProgress(userId);
      if (data == null) return null;

      final timestampString = data[_timestampKey] as String?;
      if (timestampString == null) return null;

      return DateTime.parse(timestampString);
    } catch (e) {
      return null;
    }
  }
}
