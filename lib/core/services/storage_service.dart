import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late Box _box;
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _box = await Hive.openBox('wazeet_storage');
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Hive storage methods
  static Future<void> setData(String key, dynamic value) async {
    await _box.put(key, value);
  }
  
  static T? getData<T>(String key) {
    return _box.get(key);
  }
  
  static Future<void> removeData(String key) async {
    await _box.delete(key);
  }
  
  static Future<void> clearAll() async {
    await _box.clear();
  }
  
  // SharedPreferences methods
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  static String? getString(String key) {
    return _prefs.getString(key);
  }
  
  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
  
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }
  
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
  
  static Future<void> clear() async {
    await _prefs.clear();
  }
}
