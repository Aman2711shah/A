# 🚀 Quick Firebase Setup - WAZEET App

## Step 1: Install FlutterFire CLI

Run this command in a **new terminal** (not in VS Code's terminal):

```bash
dart pub global activate flutterfire_cli
```

Add to your PATH (add this to your `~/.zshrc` file):
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Then reload your shell:
```bash
source ~/.zshrc
```

## Step 2: Install Firebase CLI (if not installed)

```bash
npm install -g firebase-tools
```

Or using curl:
```bash
curl -sL https://firebase.tools | bash
```

## Step 3: Login to Firebase

```bash
firebase login
```

This will open a browser for authentication.

## Step 4: Navigate to Your Project

```bash
cd /Users/amanshah/Documents/GitHub/A
```

## Step 5: Configure Firebase for Flutter

```bash
flutterfire configure
```

**Follow the prompts:**
1. Select "Create a new Firebase project" or choose an existing one
2. Name it "WAZEET" (or your preferred name)
3. Select platforms:
   - ✅ android
   - ✅ ios
   - ✅ macos
   - ✅ web

This will:
- Create a Firebase project (if new)
- Register your apps with Firebase
- Download configuration files
- Generate `lib/firebase_options.dart`

## Step 6: Update main.dart

After configuration, update your `lib/main.dart`:

```dart
import 'firebase_options.dart'; // Add this import

// In main() function, update Firebase initialization to:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Step 7: Enable Firebase Services

Go to [Firebase Console](https://console.firebase.google.com):

1. **Authentication**
   - Click "Get Started"
   - Enable "Email/Password"
   - Enable "Google" (optional)

2. **Firestore Database**
   - Click "Create database"
   - Start in **test mode**
   - Choose location: `asia-south1` (Mumbai)

3. **Storage**
   - Click "Get started"
   - Start in **test mode**

4. **Cloud Messaging** (optional)
   - Go to Project Settings > Cloud Messaging
   - Note your Server Key for notifications

## Step 8: Get Dependencies

```bash
flutter pub get
```

## Step 9: Run the App

```bash
flutter run -d web-server --web-port 8080
```

Check console for: `✅ Firebase initialized successfully`

## Troubleshooting

### Command not found: flutterfire

Make sure `~/.pub-cache/bin` is in your PATH:
```bash
echo $PATH | grep pub-cache
```

If not found, add to `~/.zshrc`:
```bash
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Firebase project selection fails

1. Make sure you're logged in: `firebase login --status`
2. List projects: `firebase projects:list`
3. Re-run: `flutterfire configure`

### Build errors after configuration

```bash
flutter clean
flutter pub get
flutter run
```

## What Gets Created

After running `flutterfire configure`:

- `lib/firebase_options.dart` - Firebase configuration
- `android/app/google-services.json` - Android config
- `ios/Runner/GoogleService-Info.plist` - iOS config
- `macos/Runner/GoogleService-Info.plist` - macOS config
- Web config embedded in `firebase_options.dart`

## Next Steps

1. ✅ Configure Firebase (above steps)
2. ✅ Enable services in Firebase Console
3. ✅ Update Firestore security rules
4. ✅ Test authentication
5. ✅ Start building features!

## Useful Commands

```bash
# Reconfigure Firebase
flutterfire configure

# Check Firebase login
firebase login --status

# List Firebase projects
firebase projects:list

# List apps in project
firebase apps:list

# Run app
flutter run -d web-server --web-port 8080

# Clean and rebuild
flutter clean && flutter pub get && flutter run
```

## Firebase Services Available

Your app is configured with:
- 🔐 **Firebase Authentication** - User sign up/sign in
- 📊 **Cloud Firestore** - NoSQL database
- 📁 **Firebase Storage** - File storage
- 📱 **Cloud Messaging** - Push notifications
- 📈 **Firebase Analytics** - App analytics
- 🐛 **Crashlytics** - Crash reporting

## Service Files Created

- `lib/core/services/firebase_auth_service.dart` - Auth operations
- `lib/core/services/firebase_firestore_service.dart` - Database operations
- `lib/core/services/firebase_storage_service.dart` - File uploads

## Need Help?

- Full guide: `FIREBASE_SETUP.md`
- Setup script: `./setup_firebase.sh`
- FlutterFire docs: https://firebase.flutter.dev/
- Firebase console: https://console.firebase.google.com
