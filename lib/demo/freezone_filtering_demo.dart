// Freezone Filtering Demo
// This demonstrates how the freezone filtering works with actual data
import 'package:flutter/foundation.dart';

import '../core/utils/freezone_utils.dart';

void demoFreezoneFiltering() async {
  debugPrint('🚀 WAZEET Freezone Filtering Demo\n');

  // Example user input from Company Setup form
  final userInput1 = {
    'selectedActivity': 'technology',
    'legalStructure': 'llc',
    'numberOfVisas': 2,
    'officeType': 'virtual_office',
  };

  final userInput2 = {
    'selectedActivity': 'trading',
    'legalStructure': 'sole_proprietorship',
    'numberOfVisas': 1,
    'officeType': 'physical_office',
  };

  final userInput3 = {
    'selectedActivity': 'media',
    'legalStructure': 'llc',
    'numberOfVisas': 3,
    'officeType': 'shared_office',
  };

  try {
    // Load freezone data
    debugPrint('📊 Loading freezone packages...');
    final allZones = await loadFreezones();
    debugPrint('✅ Loaded ${allZones.length} freezone packages\n');

    // Test scenario 1: Technology startup
    debugPrint('🔍 Scenario 1: Technology Startup');
    debugPrint('Requirements: $userInput1');
    final filtered1 = filterFreezones(allZones, userInput1);
    debugPrint('📈 Found ${filtered1.length} matching options:');
    _displayTop3Results(filtered1);

    // Test scenario 2: Trading business
    debugPrint('\n🔍 Scenario 2: Trading Business');
    debugPrint('Requirements: $userInput2');
    final filtered2 = filterFreezones(allZones, userInput2);
    debugPrint('📈 Found ${filtered2.length} matching options:');
    _displayTop3Results(filtered2);

    // Test scenario 3: Media company
    debugPrint('\n🔍 Scenario 3: Media Company');
    debugPrint('Requirements: $userInput3');
    final filtered3 = filterFreezones(allZones, userInput3);
    debugPrint('📈 Found ${filtered3.length} matching options:');
    _displayTop3Results(filtered3);

    debugPrint('\n✨ Demo completed successfully!');
  } catch (e) {
    debugPrint('❌ Error during demo: $e');
  }
}

void _displayTop3Results(List<Map<String, dynamic>> results) {
  final top3 = results.take(3).toList();

  for (int i = 0; i < top3.length; i++) {
    final zone = top3[i];
    final freezone = zone['Freezone'] ?? 'Unknown';
    final package = zone['Package Name'] ?? 'Standard';
   final price = zone['Price (AED)'] ?? 0;
   final visas = zone['No. of Visas Included'] ?? 0;

    debugPrint('  ${i + 1}. $freezone - $package');
    debugPrint('     💰 AED $price | 🎫 $visas visas included');
  }

  if (results.isEmpty) {
    debugPrint('  No matching freezone packages found');
  }
}

// Example of how the filtering logic works internally
void explainFilteringLogic() {
  debugPrint('\n🧠 How the Filtering Logic Works:\n');

  debugPrint('1. Activity Matching:');
  debugPrint(
      '   - Maps user selection to keywords (e.g., "technology" → ["tech", "digital", "innovation"])');
  debugPrint(
      '   - Searches freezone package names and descriptions for these keywords');
  debugPrint('   - Examples: RAK DAO matches "technology", SHAMS matches "media"\n');

  debugPrint('2. Legal Structure Matching:');
  debugPrint(
      '   - Most freezones support common structures (LLC, Sole Proprietorship)');
  debugPrint(
      '   - Currently permissive as data doesn\'t specify structure restrictions\n');

  debugPrint('3. Visa Requirements:');
  debugPrint('   - Extracts max visa capacity from "Visa Eligibility" field');
  debugPrint('   - Parses formats like "Up to 5 visa" or direct numbers');
  debugPrint('   - Ensures freezone can accommodate required visa count\n');

  debugPrint('4. Office Type Matching:');
  debugPrint('   - Maps office types to package keywords:');
  debugPrint('     • virtual_office → "license" packages');
  debugPrint('     • shared_office → "coworking" packages');
  debugPrint('     • physical_office → "serviced office" packages\n');

  debugPrint('5. Price Sorting:');
  debugPrint('   - Extracts price from "Price (AED)" field');
  debugPrint('   - Sorts results by ascending price for best value\n');
}

// Example usage in Flutter app
void integrateWithCompanySetup() {
  debugPrint('🔧 Integration with Company Setup Flow:\n');

  debugPrint('Step 1: User completes form steps (Activity, Legal, Visas, Office)');
  debugPrint('Step 2: Data stored in Map<String, dynamic> _formData');
  debugPrint('Step 3: FreezoneRecommendationsStepWidget loads recommendations');
  debugPrint('Step 4: filterFreezones() processes requirements');
  debugPrint('Step 5: Top 5 results displayed with pricing and features');
  debugPrint('Step 6: User selects preferred freezone option');
  debugPrint('Step 7: Selection stored for final application submission\n');

  debugPrint('📱 Available in Company Setup → More Tab → Company Setup');
}
