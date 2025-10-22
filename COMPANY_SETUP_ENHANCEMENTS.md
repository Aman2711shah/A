# Company Setup & Applications Enhancements

This document outlines the comprehensive enhancements made to the Company Setup and Applications tracking system.

## 🎯 Overview

Three major enhancements have been implemented:

1. **Enhanced Application Tracking** - Richer status updates with advisor information
2. **Firebase Storage Integration** - Real document uploads with URL tracking
3. **Wizard Progress Persistence** - Auto-save and resume functionality

---

## 📊 Enhanced Application Tracking

### Features Added

#### 1. **Rich Status Banner**
- Color-coded status indicators (Pending, In Review, Processing, Approved, etc.)
- Progress percentage visualization
- Large, clear status icons

#### 2. **Assigned Advisor Card**
Shows detailed information about the advisor handling your application:
- Advisor name and photo
- Contact email
- Phone number
- Support agent icon

#### 3. **Status Timeline**
Complete history of status changes:
- Chronological order (newest first)
- Timestamp for each status change
- Optional notes for each update
- Visual timeline indicators

#### 4. **Next Steps Card**
- Clear guidance on what happens next
- Highlighted in blue for visibility
- Updated as application progresses

#### 5. **Remarks/Notes Card**
- Important notes from the review team
- Highlighted in amber for attention
- Additional context and requirements

#### 6. **Enhanced Documents Display**
- Downloadable document links
- Document type icons
- File metadata (name, type, size)
- Click-to-download functionality

### Data Structure

The enhanced `Track Application` screen now expects:

```dart
{
  // Basic fields (existing)
  'status': 'in_review',
  'type': 'company_setup',
  'activity': 'General Trading',
  'legalStructure': 'LLC',
  'createdAt': Timestamp,
  'updatedAt': Timestamp,
  
  // New enhanced fields
  'completedAt': Timestamp?,  // When completed
  'progressPercentage': 45,   // 0-100
  'estimatedCompletion': '2024-11-15',
  
  // Assigned advisor
  'assignedAdvisor': {
    'name': 'Ahmed Al-Mansouri',
    'email': 'ahmed@wazeet.com',
    'phone': '+971 50 123 4567',
    'photo': 'https://...'  // Optional
  },
  
  // Status history timeline
  'statusHistory': [
    {
      'status': 'pending',
      'timestamp': Timestamp,
      'note': 'Application received'
    },
    {
      'status': 'in_review',
      'timestamp': Timestamp,
      'note': 'Assigned to advisor'
    }
  ],
  
  // Guidance
  'nextSteps': 'Please provide additional documentation...',
  'remarks': 'Your passport copy needs to be notarized',
  
  // Enhanced documents with URLs
  'documents': [
    {
      'id': 'passport_copies',
      'name': 'passport_john_doe.pdf',
      'type': 'Passport Copy',
      'url': 'https://storage.firebase.com/...',
      'size': 1024000,
      'extension': 'pdf',
      'uploadedAt': '2024-10-23T10:30:00Z'
    }
  ]
}
```

### Status Types

The system supports these status values:
- `pending` - Awaiting review (Orange)
- `in_review` - Being reviewed (Blue)
- `processing` - In process (Purple)
- `approved` - Approved (Green)
- `completed` - Completed (Green)
- `rejected` - Rejected (Red)
- `on_hold` - Temporarily on hold (Amber)

---

## 🔄 Firebase Storage Integration

### New Service: `DocumentUploadService`

Location: `lib/features/company_setup/services/document_upload_service.dart`

#### Features

1. **Multi-Platform Support**
   - Web: Upload from bytes
   - Mobile/Desktop: Upload from file path
   - Automatic platform detection

2. **File Validation**
   - Maximum size: 10MB
   - Allowed types: PDF, JPG, JPEG, PNG, DOC, DOCX
   - Clear error messages

3. **Progress Tracking**
   - Real-time upload progress
   - Callback function for UI updates

4. **Metadata Storage**
   - File details saved to Firestore
   - Document URLs linked to applications
   - Complete audit trail

#### Usage Example

```dart
final uploadService = DocumentUploadService();

try {
  final documentData = await uploadService.uploadDocument(
    documentId: 'passport_copies',
    documentType: 'Passport Copy',
    applicationId: 'APP123',
    onProgress: (progress) {
      print('Upload progress: ${(progress * 100).toStringAsFixed(0)}%');
    },
  );
  
  print('Document uploaded: ${documentData['url']}');
} catch (e) {
  print('Upload failed: $e');
}
```

#### Storage Structure

Files are organized in Firebase Storage:

```
applications/
  ├── APP123/
  │   └── documents/
  │       ├── passport_copies/
  │       │   └── passport_john_doe.pdf
  │       ├── photos/
  │       │   └── photo_john_doe.jpg
  │       └── noc_certificate/
  │           └── noc_employer.pdf
```

#### Firestore Metadata

Document metadata is stored in Firestore `documents` collection:

```dart
{
  'id': 'passport_copies',
  'name': 'passport_john_doe.pdf',
  'type': 'Passport Copy',
  'url': 'https://storage.firebase.com/...',
  'size': 1024000,
  'extension': 'pdf',
  'uploadedBy': 'user-uid-123',
  'uploadedAt': '2024-10-23T10:30:00Z',
  'applicationId': 'APP123',
  'userId': 'user-uid-123',
  'createdAt': Timestamp,
  'updatedAt': Timestamp
}
```

---

## 💾 Wizard Progress Persistence

### New Service: `WizardPersistenceService`

Location: `lib/features/company_setup/services/wizard_persistence_service.dart`

#### Features

1. **Auto-Save**
   - Automatically saves progress after each step
   - Saves when any form field changes
   - Can be toggled on/off

2. **Smart Resumption**
   - Loads saved progress on initialization
   - Returns to exact step user left off
   - Preserves all form data

3. **Auto-Expiry**
   - Progress older than 30 days automatically cleared
   - Prevents stale data accumulation

4. **User-Specific**
   - Each user has separate saved progress
   - Uses Firebase Auth UID for identification

#### Data Stored

```dart
{
  'current_step': 3,
  'last_saved': '2024-10-23T10:30:00Z',
  'form_data': {
    'selectedActivity': 'General Trading',
    'selectedLegalStructure': 'LLC',
    'numberOfShareholders': 2,
    'visaType': 'investor_visa',
    'numberOfVisas': 2,
    'officeSpaceType': 'flexi_desk',
    'hasEjari': true,
    'uploadedDocuments': ['passport_copies', 'photos'],
    'uploadedDocumentDetails': {
      'passport_copies': {
        'url': 'https://...',
        'name': 'passport.pdf',
        'size': 1024000
      }
    }
  }
}
```

#### Updated Provider Methods

```dart
// Initialize and load saved progress
await provider.initialize();

// Check if saved progress exists
final hasSaved = await provider.hasSavedProgress();

// Manually save progress
await provider.saveProgress();

// Clear saved progress
await provider.clearProgress();

// Toggle auto-save
provider.setAutoSave(false);
```

#### User Experience Flow

1. **User starts wizard** → Progress auto-saves at each step
2. **User closes app mid-way** → Progress saved to local storage
3. **User returns later** → Wizard asks to resume from last step
4. **User completes wizard** → Progress automatically cleared

---

## 🚀 Implementation Guide

### Step 1: Update Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  file_picker: ^8.0.0+1  # For document uploads
  shared_preferences: ^2.2.2  # For progress persistence
```

Run:
```bash
flutter pub get
```

### Step 2: Initialize Provider

```dart
// In your company setup screen
void initState() {
  super.initState();
  final provider = Provider.of<CompanySetupProvider>(context, listen: false);
  provider.initialize();  // Load saved progress
}
```

### Step 3: Handle Document Uploads

Update your document upload step to use the new service:

```dart
import '../services/document_upload_service.dart';

final uploadService = DocumentUploadService();

// In your upload button handler
final documentData = await uploadService.uploadDocument(
  documentId: document['id'],
  documentType: document['title'],
  applicationId: applicationId,
  onProgress: (progress) {
    setState(() {
      uploadProgress = progress;
    });
  },
);

// Add to provider with details
provider.addDocument(
  document['id'],
  details: documentData,
);
```

### Step 4: Submit Application

```dart
try {
  final applicationId = await provider.submitForm();
  
  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Application submitted! ID: $applicationId'),
      action: SnackBarAction(
        label: 'Track',
        onPressed: () {
          // Navigate to Track Application screen
        },
      ),
    ),
  );
} catch (e) {
  // Handle error
}
```

---

## 📱 UI/UX Improvements

### Track Application Screen

**Before:**
- Basic text list of fields
- No visual hierarchy
- Plain status text
- Document names only

**After:**
- Color-coded status banner
- Progress bar visualization
- Advisor contact card
- Status timeline with history
- Next steps guidance
- Downloadable documents with icons
- Professional card-based layout

### Company Setup Wizard

**Before:**
- Lost progress on exit
- Manual document entry
- No upload functionality

**After:**
- Auto-saves every step
- Resume from where you left off
- Real file uploads to Firebase Storage
- Progress indicators for uploads
- Document metadata tracking

---

## 🔒 Security Considerations

1. **File Validation**
   - File type restrictions enforced
   - Size limits prevent abuse
   - Malicious file detection (client-side)

2. **Storage Rules**
   - Firebase Storage rules should restrict access
   - Only authenticated users can upload
   - Users can only access their own documents

3. **Data Privacy**
   - Progress saved locally per user
   - No cross-user data leakage
   - Auto-expiry prevents data hoarding

### Recommended Firebase Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /applications/{applicationId}/documents/{allPaths=**} {
      // Allow read if user owns the application
      allow read: if request.auth != null && 
        firestore.get(/databases/(default)/documents/applications/$(applicationId)).data.userId == request.auth.uid;
      
      // Allow upload if authenticated and file size < 10MB
      allow write: if request.auth != null && 
        request.resource.size < 10 * 1024 * 1024 &&
        request.resource.contentType.matches('image/.*|application/pdf|application/msword|application/vnd.openxmlformats-officedocument.wordprocessingml.document');
    }
  }
}
```

---

## 🧪 Testing

### Test Scenarios

1. **Application Tracking**
   - ✅ View application with all enhanced fields
   - ✅ View application with basic fields only (backward compatible)
   - ✅ Download documents
   - ✅ View status timeline
   - ✅ See advisor information

2. **Document Upload**
   - ✅ Upload PDF file
   - ✅ Upload image file
   - ✅ Reject file > 10MB
   - ✅ Reject invalid file type
   - ✅ Track upload progress
   - ✅ Handle upload errors

3. **Progress Persistence**
   - ✅ Save progress on each step
   - ✅ Load progress on initialization
   - ✅ Resume from saved step
   - ✅ Clear progress after submission
   - ✅ Handle expired progress (>30 days)

---

## 📈 Future Enhancements

1. **Real-time Notifications**
   - Push notifications for status changes
   - Email notifications for important updates
   - In-app notification center

2. **Document Verification**
   - AI-powered document validation
   - OCR for data extraction
   - Authenticity verification

3. **Advisor Chat**
   - Direct messaging with assigned advisor
   - File sharing in chat
   - Video consultation booking

4. **Advanced Analytics**
   - Application completion funnel
   - Average processing time
   - Common drop-off points

---

## 🐛 Troubleshooting

### Documents not uploading

**Check:**
- Firebase Storage rules configured correctly
- User is authenticated
- File size < 10MB
- File type is allowed
- Internet connection is stable

### Progress not saving

**Check:**
- `shared_preferences` package installed
- Provider initialized with `initialize()`
- Auto-save is enabled
- User is authenticated (progress tied to UID)

### Application not displaying enhanced fields

**Check:**
- Firestore document has new fields
- App using latest code version
- Backward compatibility for old applications

---

## 📚 Related Documentation

- [Firebase Setup Guide](FIREBASE_SETUP.md)
- [Testing Guide](TESTING.md)
- [App Status](APP_STATUS.md)

---

## ✅ Summary

These enhancements provide:

✨ **Better User Experience**
- Visual, intuitive application tracking
- No lost progress in wizard
- Professional document management

🔧 **Technical Improvements**
- Real Firebase Storage integration
- Persistent local state management
- Comprehensive error handling

🚀 **Production Ready**
- Security considered
- Backward compatible
- Fully documented

---

**Last Updated:** October 23, 2024
**Version:** 1.0.0
