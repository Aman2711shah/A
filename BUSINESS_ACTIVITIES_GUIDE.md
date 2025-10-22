# 📋 How to Add 4000+ Business Activities to WAZEET

## Overview

You have **4,000 business activities** to manage. Here are your options:

## ✅ **Option 1: Firebase Firestore (RECOMMENDED)**

### Why Firestore?
- ✅ No app size increase (activities stay in cloud)
- ✅ Real-time updates without app republishing
- ✅ Fast search and filtering (indexed)
- ✅ Easy to update/add new activities
- ✅ Multi-language support ready
- ✅ Works offline with caching
- ✅ Scales to millions of records

### How It Works
1. Upload activities to Firestore once
2. App fetches and caches them
3. Users search/filter in real-time
4. Update anytime from Firebase Console

---

## 🚀 Step-by-Step Setup

### Step 1: Prepare Your Data

You can use **CSV** or **JSON** format.

#### **CSV Format** (Recommended for Excel/Google Sheets)

Create a file: `business_activities.csv`

```csv
Name,Name_Arabic,Code,Category,License_Type,Description,Description_Arabic,Requires_Approval,Approval_Authority,Compatible_Freezones,Required_Documents,Fees
General Trading,التجارة العامة,GT-001,Trading,commercial,Import export and trade,استيراد وتصدير,No,,DMCC|JAFZA|DAFZA,Trade License|Passport,0
Software Development,تطوير البرمجيات,IT-001,Technology,professional,Software development,تطوير البرمجيات,No,,DTEC|DMCC,Professional License,0
Restaurant Services,خدمات المطاعم,F&B-001,Food & Beverage,commercial,Restaurant operations,عمليات المطاعم,Yes,Dubai Municipality,DMCC|JAFZA,Trade License|Food Permit,0
```

**Column Definitions:**
- `Name` - English name (required)
- `Name_Arabic` - Arabic name (optional)
- `Code` - Unique code (required)
- `Category` - Category name (Trading, Technology, Healthcare, etc.)
- `License_Type` - commercial, professional, industrial, or tourism
- `Description` - English description
- `Description_Arabic` - Arabic description
- `Requires_Approval` - Yes/No
- `Approval_Authority` - Which authority (if approval needed)
- `Compatible_Freezones` - Pipe-separated list (DMCC|JAFZA|DAFZA)
- `Required_Documents` - Pipe-separated list
- `Fees` - Additional fees if any

#### **JSON Format** (More structured)

Create a file: `business_activities.json`

```json
[
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
]
```

### Step 2: Create Upload Script

I've already created the upload scripts for you:
- ✅ `lib/core/services/business_activity_service.dart` - Service class
- ✅ `lib/scripts/upload_business_activities.dart` - Upload script

### Step 3: Upload to Firestore

Create a simple Flutter app to run the upload:

```dart
// lib/scripts/run_upload.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'upload_business_activities.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UploadApp());
}

class UploadApp extends StatelessWidget {
  const UploadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Upload Business Activities')),
        body: const UploadScreen(),
      ),
    );
  }
}

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _uploading = false;
  String _status = 'Ready to upload';

  Future<void> _uploadActivities() async {
    setState(() {
      _uploading = true;
      _status = 'Uploading...';
    });

    try {
      final uploader = BusinessActivityUploader();
      
      // Upload from JSON (put your file path here)
      await uploader.uploadFromJson('assets/data/business_activities.json');
      
      // OR upload from CSV
      // await uploader.uploadFromCsv('assets/data/business_activities.csv');
      
      setState(() {
        _status = '✅ Upload complete!';
        _uploading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_status, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploading ? null : _uploadActivities,
            child: _uploading
                ? const CircularProgressIndicator()
                : const Text('Upload Activities'),
          ),
        ],
      ),
    );
  }
}
```

### Step 4: Run Upload

```bash
# 1. Place your data file
# Copy your CSV or JSON to: assets/data/business_activities.csv

# 2. Update pubspec.yaml to include the file
# Add under assets:
#   - assets/data/business_activities.csv

# 3. Run the upload script
flutter run lib/scripts/run_upload.dart

# 4. Click "Upload Activities" button

# 5. Wait for completion (may take 2-5 minutes for 4000 activities)
```

### Step 5: Use in Your App

```dart
import 'package:wazeet_app/core/services/business_activity_service.dart';

class CompanySetupScreen extends StatefulWidget {
  // ... your code
}

class _CompanySetupScreenState extends State<CompanySetupScreen> {
  final BusinessActivityService _activityService = BusinessActivityService();
  List<Map<String, dynamic>> _activities = [];
  List<Map<String, dynamic>> _filteredActivities = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final activities = await _activityService.getAllActivities();
    setState(() {
      _activities = activities;
      _filteredActivities = activities;
    });
  }

  void _searchActivities(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredActivities = _activities;
      } else {
        _filteredActivities = _activities.where((activity) {
          final name = activity['name'].toString().toLowerCase();
          final code = activity['code'].toString().toLowerCase();
          return name.contains(query.toLowerCase()) ||
              code.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search Business Activity',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _searchActivities,
        ),
        
        // Results
        Expanded(
          child: ListView.builder(
            itemCount: _filteredActivities.length,
            itemBuilder: (context, index) {
              final activity = _filteredActivities[index];
              return ListTile(
                title: Text(activity['name']),
                subtitle: Text(activity['code']),
                trailing: Text(activity['category']),
                onTap: () {
                  // Handle selection
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
```

---

## 📊 Alternative Options

### **Option 2: JSON Asset File** (Simpler, but increases app size)

If you want to keep it simple and don't mind app size:

1. Create `assets/data/business_activities.json`
2. Add all 4000 activities
3. Load in app:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadActivities() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/business_activities.json'
  );
  final List<dynamic> data = json.decode(jsonString);
  return data.cast<Map<String, dynamic>>();
}
```

**Pros:**
- ✅ Works offline immediately
- ✅ No Firebase needed
- ✅ Simple setup

**Cons:**
- ❌ Increases app size (~500KB for 4000 activities)
- ❌ Need app update to change activities
- ❌ Slower search for large datasets

### **Option 3: Hybrid Approach** (Best of both worlds)

1. Bundle 50-100 most popular activities in app (JSON asset)
2. Load full list from Firestore on first launch
3. Cache in local database (Hive/SQLite)

---

## 🎯 Recommended Approach

For **4,000 business activities**, I recommend:

1. **Use Firestore** (Option 1) ✅
2. **Cache locally** with Hive for offline access
3. **Index by category** for fast filtering
4. **Mark popular activities** for quick access

This gives you:
- ✅ Small app size
- ✅ Fast performance
- ✅ Easy updates
- ✅ Offline support
- ✅ Scalability

---

## 📁 Data Structure in Firestore

```
business_activities (collection)
  ├── doc1 (auto-generated ID)
  │   ├── name: "General Trading"
  │   ├── nameAr: "التجارة العامة"
  │   ├── code: "GT-001"
  │   ├── category: "Trading"
  │   ├── licenseType: "commercial"
  │   ├── description: "..."
  │   ├── requiresApproval: false
  │   ├── compatibleFreezones: ["DMCC", "JAFZA"]
  │   ├── requiredDocuments: ["Trade License"]
  │   ├── usageCount: 0
  │   ├── isPopular: false
  │   ├── createdAt: timestamp
  │   └── updatedAt: timestamp
  │
  ├── doc2
  ├── doc3
  └── ... (4000 documents)
```

---

## 🔍 Firestore Indexes

Create these indexes in Firebase Console for fast queries:

1. **Composite Index:**
   - Collection: `business_activities`
   - Fields: `category` (Ascending) + `name` (Ascending)

2. **Composite Index:**
   - Collection: `business_activities`
   - Fields: `licenseType` (Ascending) + `name` (Ascending)

3. **Composite Index:**
   - Collection: `business_activities`
   - Fields: `isPopular` (Descending) + `usageCount` (Descending)

---

## 💡 Tips

1. **Prepare your data** in Excel/Google Sheets first
2. **Export to CSV** (easier to edit than JSON)
3. **Test with 10 activities** first before uploading all 4000
4. **Use batch upload** (script handles this automatically)
5. **Monitor Firestore usage** in Firebase Console
6. **Set up security rules** to prevent unauthorized access

---

## 🆘 Need Help?

**I have the data in Excel:**
1. Save as CSV
2. Use the upload script
3. Run `flutter run lib/scripts/run_upload.dart`

**I have the data in a database:**
1. Export to JSON
2. Use `uploadFromJson()` method

**I want to test first:**
1. Create a small sample (10 activities)
2. Upload and test
3. Then upload all 4000

---

## 📞 Support

Check the created files:
- `lib/core/services/business_activity_service.dart` - Full service
- `lib/scripts/upload_business_activities.dart` - Upload script

Next steps:
1. Prepare your data (CSV or JSON)
2. Configure Firebase (if not done)
3. Run the upload script
4. Integrate into your Company Setup flow
