import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class FreezoneFilterService {
  static Future<List<dynamic>> loadFreezones() async {
    final raw =
        await rootBundle.loadString('assets/data/freezone_packages.json');
    return json.decode(raw);
  }

  static List<Map<String, dynamic>> filterFreezones(
      List<dynamic> allZones, Map<String, dynamic> userInput) {
    // Convert dynamic list to list of maps for easier processing
    final zones = allZones.cast<Map<String, dynamic>>();

    return zones.where((zone) {
      // Activity matching - more flexible approach since data has varied activity fields
      bool matchActivity =
          _matchesActivity(zone, userInput['selectedActivity']);

      // Legal structure matching - freezone data doesn't have direct legal structure field
      // We'll assume most freezones support common structures
      bool matchStructure =
          _matchesLegalStructure(zone, userInput['legalStructure']);

      // Visa count matching
      bool matchVisas =
          _matchesVisaRequirement(zone, userInput['numberOfVisas'] ?? 0);

      // Office type matching - based on package names and descriptions
      bool matchOffice = _matchesOfficeType(zone, userInput['officeType']);

      return matchActivity && matchStructure && matchVisas && matchOffice;
    }).toList()
      ..sort((a, b) {
        // Sort by price - handle different price field names
        final priceA = _extractPrice(a);
        final priceB = _extractPrice(b);
        return priceA.compareTo(priceB);
      });
  }

  static bool _matchesActivity(
      Map<String, dynamic> zone, String? selectedActivity) {
    if (selectedActivity == null) return true;

    // Map our activity IDs to keywords that might appear in freezone data
    const activityKeywords = {
      'trading': ['trading', 'import', 'export', 'general'],
      'consulting': ['consulting', 'advisory', 'business'],
      'technology': ['technology', 'tech', 'digital', 'innovation', 'web3'],
      'retail': ['retail', 'ecommerce', 'trading'],
      'real_estate': ['real estate', 'property', 'development'],
      'healthcare': ['healthcare', 'medical', 'health'],
      'education': ['education', 'training', 'learning'],
      'hospitality': ['hospitality', 'tourism', 'hotel'],
      'manufacturing': ['manufacturing', 'production', 'industrial'],
      'finance': ['finance', 'financial', 'banking'],
      'media': ['media', 'entertainment', 'creative'],
      'other': [], // Other matches everything
    };

    final keywords = activityKeywords[selectedActivity] ?? [];
    if (keywords.isEmpty) return true; // 'other' or unknown activity

    // Check various fields that might contain activity information
    final searchFields = [
      zone['Package Name']?.toString().toLowerCase() ?? '',
      zone['No. of Activities Allowed']?.toString().toLowerCase() ?? '',
      zone['Other Costs / Notes']?.toString().toLowerCase() ?? '',
      zone['Freezone']?.toString().toLowerCase() ?? '',
    ];

    final searchText = searchFields.join(' ');

    return keywords
        .any((keyword) => searchText.contains(keyword.toLowerCase()));
  }

  static bool _matchesLegalStructure(
      Map<String, dynamic> zone, String? legalStructure) {
    // Most freezones support common legal structures
    // We'll be permissive here since the data doesn't specify legal structures explicitly
    return true;
  }

  static bool _matchesVisaRequirement(
      Map<String, dynamic> zone, int requiredVisas) {
    if (requiredVisas == 0) return true;

    // Try to extract visa information from various fields
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
        final maxVisas = int.tryParse(upToMatch.group(1) ?? '0') ?? 0;
        if (maxVisas >= requiredVisas) return true;
      }

      // Handle direct number
      if (field is int && field >= requiredVisas) return true;

      // Handle string numbers
      final directNumber = int.tryParse(fieldStr);
      if (directNumber != null && directNumber >= requiredVisas) return true;
    }

    // If no visa info found, assume it's possible (additional cost)
    return true;
  }

  static bool _matchesOfficeType(
      Map<String, dynamic> zone, String? officeType) {
    if (officeType == null) return true;

    const officeKeywords = {
      'physical_office': ['serviced office', 'office', 'physical'],
      'virtual_office': ['virtual', 'license'],
      'shared_office': ['coworking', 'shared', 'co-working'],
      'home_office': [
        'license',
        'virtual'
      ], // Many license-only packages allow home office
    };

    final keywords = officeKeywords[officeType] ?? [];
    if (keywords.isEmpty) return true;

    final packageName = zone['Package Name']?.toString().toLowerCase() ?? '';
    final notes = zone['Other Costs / Notes']?.toString().toLowerCase() ?? '';

    final searchText = '$packageName $notes';

    return keywords
        .any((keyword) => searchText.contains(keyword.toLowerCase()));
  }

  static double _extractPrice(Map<String, dynamic> zone) {
    // Try different price field names
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

  static Map<String, dynamic> calculateTotalCost(
      Map<String, dynamic> zone, Map<String, dynamic> userInput) {
    final basePrice = _extractPrice(zone);
    final requiredVisas = userInput['numberOfVisas'] ?? 0;

    var totalCost = basePrice;
    var breakdown = <String, dynamic>{
      'base_price': basePrice,
      'visa_costs': 0.0,
      'additional_fees': 0.0,
      'total': basePrice,
    };

    // Add visa costs if needed
    if (requiredVisas > 0) {
      final includedVisas = _getIncludedVisas(zone);
      final additionalVisas =
          (requiredVisas - includedVisas).clamp(0, requiredVisas);

      if (additionalVisas > 0) {
        final visaCost = _getVisaCost(zone);
        final totalVisaCost = additionalVisas * visaCost;

        breakdown['visa_costs'] = totalVisaCost;
        totalCost += totalVisaCost;
      }
    }

    // Add other fees
    final additionalFees = _calculateAdditionalFees(zone);
    breakdown['additional_fees'] = additionalFees;
    totalCost += additionalFees;

    breakdown['total'] = totalCost;

    return breakdown;
  }

  static int _getIncludedVisas(Map<String, dynamic> zone) {
    final visaField = zone['No. of Visas Included'];

    if (visaField is int) return visaField;
    if (visaField is String) {
      final parsed = int.tryParse(visaField);
      if (parsed != null) return parsed;
    }

    return 0;
  }

  static double _getVisaCost(Map<String, dynamic> zone) {
    final visaCostField = zone['Visa Cost (AED)'];

    if (visaCostField is num) return visaCostField.toDouble();
    if (visaCostField is String) {
      final cleaned = visaCostField.replaceAll(RegExp(r'[^\d.]'), '');
      final parsed = double.tryParse(cleaned);
      if (parsed != null) return parsed;
    }

    // Default visa cost estimate
    return 3500.0;
  }

  static double _calculateAdditionalFees(Map<String, dynamic> zone) {
    var additionalFees = 0.0;

    final feeFields = [
      'Immigration Card Fee',
      'E-Channel Fee',
      'Medical Fee',
      'Emirates ID Fee',
      'Change of Status Fee',
    ];

    for (final field in feeFields) {
      final value = zone[field];
      if (value == null || value.toString().toLowerCase().contains('included')) {
        continue;
      }

      if (value is num) {
        additionalFees += value.toDouble();
      } else if (value is String) {
        final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
        final parsed = double.tryParse(cleaned);
        if (parsed != null) additionalFees += parsed;
      }
    }

    return additionalFees;
  }

  static List<Map<String, dynamic>> getTopRecommendations(
      List<Map<String, dynamic>> filteredZones, Map<String, dynamic> userInput,
      {int limit = 5}) {
    // Calculate total costs for each zone
    final zonesWithCosts = filteredZones.map((zone) {
      final costBreakdown = calculateTotalCost(zone, userInput);
      return {
        ...zone,
        'cost_breakdown': costBreakdown,
        'total_cost': costBreakdown['total'],
      };
    }).toList();

    // Sort by total cost
    zonesWithCosts.sort((a, b) =>
        (a['total_cost'] as double).compareTo(b['total_cost'] as double));

    return zonesWithCosts.take(limit).toList();
  }
}
