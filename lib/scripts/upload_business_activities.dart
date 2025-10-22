// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script to upload 4000+ business activities to Firestore
///
/// Usage:
/// 1. Prepare your CSV/JSON file with business activities
/// 2. Run this script: flutter run lib/scripts/upload_business_activities.dart
/// 3. Activities will be uploaded in batches of 500
class BusinessActivityUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload from JSON file
  Future<void> uploadFromJson(String filePath) async {
    try {
      debugPrint('📂 Reading file: $filePath');
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final List<dynamic> activities = json.decode(jsonString);

      debugPrint('📊 Found ${activities.length} activities');
      await _batchUpload(activities.cast<Map<String, dynamic>>());
      debugPrint('✅ Upload complete!');
    } catch (e) {
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  // Upload from CSV file
  Future<void> uploadFromCsv(String filePath) async {
    try {
      debugPrint('📂 Reading CSV file: $filePath');
      final file = File(filePath);
      final lines = await file.readAsLines();

      if (lines.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // Parse CSV
      final headers = _parseCsvLine(lines[0]);
      final activities = <Map<String, dynamic>>[];

      for (int i = 1; i < lines.length; i++) {
        final values = _parseCsvLine(lines[i]);
        if (values.length == headers.length) {
          final activity = <String, dynamic>{};
          for (int j = 0; j < headers.length; j++) {
            activity[headers[j]] = values[j];
          }
          activities.add(activity);
        }
      }

      debugPrint('📊 Parsed ${activities.length} activities');
      await _batchUpload(activities);
      debugPrint('✅ Upload complete!');
    } catch (e) {
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  // Parse CSV line (handles quoted fields)
  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(buffer.toString().trim());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    result.add(buffer.toString().trim());
    return result;
  }

  // Batch upload to Firestore
  Future<void> _batchUpload(List<Map<String, dynamic>> activities) async {
    final batchSize = 500; // Firestore batch limit
    final totalBatches = (activities.length / batchSize).ceil();

    debugPrint('🚀 Uploading in $totalBatches batches...');

    for (int i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (start + batchSize < activities.length)
          ? start + batchSize
          : activities.length;
      final batch = _firestore.batch();

      debugPrint(
          '📦 Batch ${i + 1}/$totalBatches: Uploading ${end - start} activities');

      for (int j = start; j < end; j++) {
        final activity = activities[j];
        final docRef = _firestore.collection('business_activities').doc();

        // Ensure required fields
        final data = {
          'name': activity['name'] ?? activity['Name'] ?? '',
          'nameAr': activity['nameAr'] ?? activity['Name_Arabic'] ?? '',
          'code': activity['code'] ?? activity['Code'] ?? '',
          'category': activity['category'] ?? activity['Category'] ?? 'General',
          'licenseType': activity['licenseType'] ??
              activity['License_Type'] ??
              'commercial',
          'description':
              activity['description'] ?? activity['Description'] ?? '',
          'descriptionAr':
              activity['descriptionAr'] ?? activity['Description_Arabic'] ?? '',
          'requiresApproval': activity['requiresApproval'] ??
              activity['Requires_Approval'] == 'Yes',
          'approvalAuthority': activity['approvalAuthority'] ??
              activity['Approval_Authority'] ??
              '',
          'compatibleFreezones': _parseArray(activity['compatibleFreezones'] ??
              activity['Compatible_Freezones']),
          'requiredDocuments': _parseArray(
              activity['requiredDocuments'] ?? activity['Required_Documents']),
          'fees': activity['fees'] ?? 0,
          'isPopular': false,
          'usageCount': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        batch.set(docRef, data);
      }

      await batch.commit();
      debugPrint('✅ Batch ${i + 1}/$totalBatches complete');

      // Small delay between batches to avoid rate limits
      if (i < totalBatches - 1) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  // Parse array fields (can be comma-separated string or array)
  List<String> _parseArray(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  // Create sample JSON template
  static String getSampleJsonTemplate() {
    return json.encode([
      {
        "name": "General Trading",
        "nameAr": "التجارة العامة",
        "code": "GT-001",
        "category": "Trading",
        "licenseType": "commercial",
        "description": "Import, export and trade of general commodities",
        "descriptionAr": "استيراد وتصدير والتجارة في السلع العامة",
        "requiresApproval": false,
        "approvalAuthority": "",
        "compatibleFreezones": ["DMCC", "JAFZA", "DAFZA", "DIFC"],
        "requiredDocuments": ["Trade License", "Passport Copy", "Visa Copy"],
        "fees": 0
      },
      {
        "name": "Software Development",
        "nameAr": "تطوير البرمجيات",
        "code": "IT-001",
        "category": "Technology",
        "licenseType": "professional",
        "description": "Development of software applications and systems",
        "descriptionAr": "تطوير تطبيقات وأنظمة البرمجيات",
        "requiresApproval": false,
        "approvalAuthority": "",
        "compatibleFreezones": ["DTEC", "DMCC", "DAFZA", "SHAMS"],
        "requiredDocuments": ["Professional License", "Passport Copy"],
        "fees": 0
      }
    ]);
  }

  // Create sample CSV template
  static String getSampleCsvTemplate() {
    return '''Name,Name_Arabic,Code,Category,License_Type,Description,Description_Arabic,Requires_Approval,Approval_Authority,Compatible_Freezones,Required_Documents,Fees
General Trading,التجارة العامة,GT-001,Trading,commercial,Import export and trade of general commodities,استيراد وتصدير والتجارة في السلع العامة,No,,DMCC|JAFZA|DAFZA,Trade License|Passport Copy,0
Software Development,تطوير البرمجيات,IT-001,Technology,professional,Development of software applications,تطوير تطبيقات البرمجيات,No,,DTEC|DMCC,Professional License|Passport Copy,0''';
  }
}

// Example usage (run this in a Flutter app or script)
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  final uploader = BusinessActivityUploader();

  // Option 1: Upload from JSON
  // await uploader.uploadFromJson('assets/data/business_activities.json');

  // Option 2: Upload from CSV
  // await uploader.uploadFromCsv('assets/data/business_activities.csv');

  // Option 3: Print templates
  print('JSON Template:');
  print(BusinessActivityUploader.getSampleJsonTemplate());
  print('\nCSV Template:');
  print(BusinessActivityUploader.getSampleCsvTemplate());
}
