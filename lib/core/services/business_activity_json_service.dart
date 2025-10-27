import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/company_setup/models/business_activity_model.dart';

class BusinessActivityJsonService {
  static List<BusinessActivityModel>? _cachedActivities;
  static List<String>? _cachedSectors;

  // Load all activities from JSON file
  static Future<List<BusinessActivityModel>> loadActivities() async {
    if (_cachedActivities != null) {
      return _cachedActivities!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/business_activities.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      _cachedActivities =
          jsonData.map((json) => BusinessActivityModel.fromJson(json)).toList();

      return _cachedActivities!;
    } catch (e) {
      print('Error loading business activities: $e');
      return [];
    }
  }

  // Get unique sectors
  static Future<List<String>> getSectors() async {
    if (_cachedSectors != null) {
      return _cachedSectors!;
    }

    final activities = await loadActivities();
    final sectors = activities.map((a) => a.sector).toSet().toList();
    sectors.sort();
    _cachedSectors = sectors;
    return sectors;
  }

  // Search activities by name
  static Future<List<BusinessActivityModel>> searchActivities(
      String query) async {
    if (query.isEmpty) return [];

    final activities = await loadActivities();
    final lowerQuery = query.toLowerCase();

    return activities.where((activity) {
      return activity.activityName.toLowerCase().contains(lowerQuery) ||
          activity.activityNameArabic.contains(query) ||
          activity.sector.toLowerCase().contains(lowerQuery) ||
          activity.isicCode.contains(query);
    }).toList();
  }

  // Get activities by sector
  static Future<List<BusinessActivityModel>> getActivitiesBySector(
      String sector) async {
    final activities = await loadActivities();
    return activities.where((a) => a.sector == sector).toList();
  }

  // Get popular activities
  static Future<List<BusinessActivityModel>> getPopularActivities() async {
    final activities = await loadActivities();
    return activities.where((a) => a.isPopular).take(10).toList();
  }

  // Get activities by license type
  static Future<List<BusinessActivityModel>> getActivitiesByLicenseType(
      String licenseType) async {
    final activities = await loadActivities();
    return activities
        .where(
            (a) => a.mainLicenseType.toLowerCase() == licenseType.toLowerCase())
        .toList();
  }

  // Clear cache
  static void clearCache() {
    _cachedActivities = null;
    _cachedSectors = null;
  }
}
