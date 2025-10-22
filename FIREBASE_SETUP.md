# 🔥 Firebase Setup Guide for WAZEET App

## Prerequisites
- Firebase account (create one at https://console.firebase.google.com)
- Flutter and Dart installed
- FlutterFire CLI installed

## Step 1: Install FlutterFire CLI

Run this command in your terminal:
```bash
dart pub global activate flutterfire_cli
```

Make sure the pub cache bin directory is in your PATH:
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

## Step 2: Login to Firebase

```bash
firebase login
```

If you don't have Firebase CLI installed:
```bash
npm install -g firebase-tools
```

## Step 3: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Add project"
3. Name it "WAZEET" (or your preferred name)
4. Enable Google Analytics (optional)
5. Create the project

## Step 4: Configure Firebase for Flutter

Navigate to your project root and run:
```bash
cd /Users/amanshah/Documents/GitHub/A
flutterfire configure
```

This will:
- Detect your platforms (iOS, Android, Web, macOS)
- Create/select a Firebase project
- Register your apps
- Generate `firebase_options.dart` file
- Download configuration files

**Select the following when prompted:**
- Select your Firebase project (WAZEET)
- Select platforms: iOS, Android, Web, macOS
- Use default package names or customize

## Step 5: Enable Firebase Services

In Firebase Console (https://console.firebase.google.com):

### 5.1 Authentication
1. Go to **Build > Authentication**
2. Click "Get Started"
3. Enable sign-in methods:
   - ✅ Email/Password
   - ✅ Google
   - ✅ Phone (optional)
   - ✅ Anonymous (for testing)

### 5.2 Cloud Firestore
1. Go to **Build > Firestore Database**
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose location: `asia-south1` (Mumbai) or nearest
5. Click "Enable"

### 5.3 Storage
1. Go to **Build > Storage**
2. Click "Get started"
3. Start in **test mode**
4. Choose location: same as Firestore
5. Click "Done"

### 5.4 Cloud Messaging (FCM)
1. Go to **Build > Cloud Messaging**
2. Click "Get started"
3. For Android: Add SHA-256 certificate fingerprint
4. For iOS: Upload APNs certificate (optional)

### 5.5 Analytics
Already enabled if you chose it during project creation.

### 5.6 Crashlytics
1. Go to **Build > Crashlytics**
2. Click "Get started"
3. Follow the setup instructions

## Step 6: Firestore Security Rules

Go to **Firestore > Rules** and update:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Companies collection
    match /companies/{companyId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (resource == null || resource.data.ownerId == request.auth.uid);
    }
    
    // Applications collection
    match /applications/{applicationId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Services collection (read-only for all authenticated users)
    match /services/{serviceId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins via Firebase Console
    }
    
    // Documents collection
    match /documents/{documentId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

## Step 7: Storage Security Rules

Go to **Storage > Rules** and update:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /companies/{companyId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /documents/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 8: Android Configuration

The FlutterFire CLI should have created `android/app/google-services.json`.

Verify in `android/app/build.gradle`:
```gradle
dependencies {
    // ... other dependencies
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
}
```

And in `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}

plugins {
    id 'com.google.gms.google-services' version '4.4.2' apply false
}
```

## Step 9: iOS Configuration

The FlutterFire CLI should have created `ios/Runner/GoogleService-Info.plist`.

Verify it's added to Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Check `GoogleService-Info.plist` is in the Runner folder
3. Verify it's included in "Copy Bundle Resources"

## Step 10: Web Configuration

For web support, the configuration is in `firebase_options.dart`.

## Step 11: Test Firebase Connection

Run the app:
```bash
flutter run -d web-server --web-port 8080
```

Check the console for:
```
✅ Firebase initialized successfully
```

## Step 12: Firestore Data Structure

Create these collections in Firestore Console:

### `users` collection
```json
{
  "userId": "auto-generated-id",
  "email": "user@example.com",
  "name": "John Doe",
  "phone": "+971501234567",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "profile": {
    "avatar": "url",
    "company": "Company Name",
    "role": "Business Owner"
  }
}
```

### `companies` collection
```json
{
  "companyId": "auto-generated-id",
  "userId": "user-id",
  "ownerId": "user-id",
  "name": "Company Name",
  "tradeLicense": "123456",
  "status": "active|pending|inactive",
  "type": "LLC|Freezone|Branch",
  "freezone": "DMCC|DIFC|etc",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### `applications` collection
```json
{
  "applicationId": "auto-generated-id",
  "userId": "user-id",
  "serviceType": "company_setup|visa|license",
  "status": "pending|processing|completed|rejected",
  "details": {},
  "documents": [],
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "completedAt": "timestamp|null"
}
```

### `services` collection
```json
{
  "serviceId": "auto-generated-id",
  "category": "visa|company|growth|accounting",
  "name": "Service Name",
  "description": "Description",
  "pricing": {
    "premium": 5000,
    "standard": 3000
  },
  "timeline": {
    "premium": "5-7 days",
    "standard": "7-10 days"
  },
  "active": true
}
```

## Troubleshooting

### Error: "Default Firebase app not initialized"
- Run `flutterfire configure` again
- Check `firebase_options.dart` exists
- Verify `Firebase.initializeApp()` is called in `main.dart`

### Error: "No Firebase App '[DEFAULT]' has been created"
- For iOS: Check `GoogleService-Info.plist` is in Xcode project
- For Android: Check `google-services.json` is in `android/app/`
- For Web: Check `firebase_options.dart` has web configuration

### Build fails on Android
- Update Google Services plugin version
- Clean and rebuild: `flutter clean && flutter pub get`
- Check `android/app/build.gradle` has correct dependencies

### Firestore permission denied
- Update Firestore rules to allow read/write in test mode:
```javascript
allow read, write: if true; // FOR TESTING ONLY
```

## Next Steps

1. ✅ Run `flutterfire configure`
2. ✅ Enable Authentication in Firebase Console
3. ✅ Enable Firestore Database
4. ✅ Enable Storage
5. ✅ Update Security Rules
6. ✅ Test the connection
7. ✅ Start building features!

## Useful Commands

```bash
# Reconfigure Firebase
flutterfire configure

# Update Firebase packages
flutter pub upgrade firebase_core firebase_auth cloud_firestore

# Clean build
flutter clean
flutter pub get
flutter run

# View Firebase logs
firebase projects:list
firebase apps:list

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage
```

## Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
