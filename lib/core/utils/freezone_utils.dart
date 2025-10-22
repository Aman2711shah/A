import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<dynamic>> loadFreezones() async {
  final raw = await rootBundle.loadString('assets/data/freezone_packages.json');
  return json.decode(raw);
}

List<Map<String, dynamic>> filterFreezones(
    List<dynamic> allZones, Map<String, dynamic> userInput) {
  return allZones.cast<Map<String, dynamic>>().where((zone) {
    bool matchActivity = zone['activities']?.contains(userInput['activity']) ??
        _matchesActivityFallback(zone, userInput['selectedActivity']);
    bool matchStructure =
        zone['legal_structures']?.contains(userInput['legalStructure']) ??
            _matchesLegalStructureFallback(zone, userInput['legalStructure']);
    bool matchVisas =
        (userInput['visaCount'] ?? userInput['numberOfVisas'] ?? 0) <=
            (zone['max_visas'] ?? _extractMaxVisas(zone));
    bool matchOffice =
        zone['office_types']?.contains(userInput['officeType']) ??
            _matchesOfficeTypeFallback(zone, userInput['officeType']);
    return matchActivity && matchStructure && matchVisas && matchOffice;
  }).toList()
    ..sort((a, b) => (a['base_price'] ?? _extractPrice(a))
        .compareTo((b['base_price'] ?? _extractPrice(b))));
}

// Fallback functions for the actual JSON structure we have
bool _matchesActivityFallback(
    Map<String, dynamic> zone, String? selectedActivity) {
  if (selectedActivity == null) return true;

  const activityKeywords = {
    'trading': ['trading', 'import', 'export', 'general'],
    'consulting': ['consulting', 'advisory', 'business'],
    'technology': ['technology', 'tech', 'digital', 'innovation', 'web3'],
    'retail': ['retail', 'ecommerce', 'trading'],
    'real_estate': ['real estate', 'property'],
    'healthcare': ['healthcare', 'medical'],
    'education': ['education', 'training'],
    'hospitality': ['hospitality', 'tourism'],
    'manufacturing': ['manufacturing', 'production'],
    'finance': ['finance', 'financial'],
    'media': ['media', 'entertainment'],
  };

  final keywords = activityKeywords[selectedActivity] ?? [];
  if (keywords.isEmpty) return true;

  final searchFields = [
    zone['Package Name']?.toString().toLowerCase() ?? '',
    zone['No. of Activities Allowed']?.toString().toLowerCase() ?? '',
    zone['Freezone']?.toString().toLowerCase() ?? '',
  ];

  final searchText = searchFields.join(' ');
  return keywords.any((keyword) => searchText.contains(keyword.toLowerCase()));
}

bool _matchesLegalStructureFallback(
    Map<String, dynamic> zone, String? legalStructure) {
  // Most freezones support common legal structures
  return true;
}

int _extractMaxVisas(Map<String, dynamic> zone) {
  final visaFields = [
    zone['No. of Visas Included'],
    zone['Visa Eligibility'],
  ];

  for (final field in visaFields) {
    if (field == null) continue;

    final fieldStr = field.toString().toLowerCase();

    // Handle "Up to X visa" format
    final upToMatch = RegExp(r'up to (\d+)').firstMatch(fieldStr);
    if (upToMatch != null) {
      return int.tryParse(upToMatch.group(1) ?? '0') ?? 0;
    }

    // Handle direct number
    if (field is int) return field;

    // Handle string numbers
    final directNumber = int.tryParse(fieldStr);
    if (directNumber != null) return directNumber;
  }

  return 10; // Default assumption for unlimited visa packages
}

bool _matchesOfficeTypeFallback(Map<String, dynamic> zone, String? officeType) {
  if (officeType == null) return true;

  const officeKeywords = {
    'physical_office': ['serviced office', 'office'],
    'virtual_office': ['license'],
    'shared_office': ['coworking', 'co-working'],
    'home_office': ['license'],
  };

  final keywords = officeKeywords[officeType] ?? [];
  if (keywords.isEmpty) return true;

  final packageName = zone['Package Name']?.toString().toLowerCase() ?? '';
  return keywords.any((keyword) => packageName.contains(keyword.toLowerCase()));
}

double _extractPrice(Map<String, dynamic> zone) {
  final priceFields = ['Price (AED)', 'price', 'base_price'];

  for (final field in priceFields) {
    final value = zone[field];
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), ''));
      if (parsed != null) return parsed;
    }
  }

  return 0.0;
}
