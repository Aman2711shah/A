#!/bin/bash

# Quick Firebase Configuration Script for WAZEET App
# Run this after installing FlutterFire CLI and Firebase CLI

echo "🔥 WAZEET Firebase Configuration"
echo "================================"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

echo "📍 Current directory: $(pwd)"
echo ""

# Check if flutterfire is available
if command -v flutterfire &> /dev/null; then
    echo "✅ FlutterFire CLI found"
else
    echo "❌ FlutterFire CLI not found"
    echo "   Run: dart pub global activate flutterfire_cli"
    echo "   Add to PATH: export PATH=\"\$PATH\":\"\$HOME/.pub-cache/bin\""
    exit 1
fi

# Check if firebase is available
if command -v firebase &> /dev/null; then
    echo "✅ Firebase CLI found"
else
    echo "⚠️  Firebase CLI not found"
    echo "   Run: npm install -g firebase-tools"
    echo ""
fi

# Check Firebase login status
echo ""
echo "🔐 Checking Firebase authentication..."
if firebase login --status &> /dev/null; then
    echo "✅ Logged in to Firebase"
else
    echo "⚠️  Not logged in to Firebase"
    echo "   Run: firebase login"
    echo ""
    read -p "Would you like to login now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        firebase login
    else
        echo "Please login manually: firebase login"
        exit 1
    fi
fi

echo ""
echo "🚀 Running FlutterFire configuration..."
echo ""
echo "You will be prompted to:"
echo "  1. Select or create a Firebase project"
echo "  2. Choose platforms (select: iOS, Android, Web, macOS)"
echo "  3. Confirm app registration"
echo ""
read -p "Press ENTER to continue..."

# Run flutterfire configure
flutterfire configure

echo ""
echo "✅ Firebase configuration complete!"
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Check that firebase_options.dart was created:"
echo "   ls -la lib/firebase_options.dart"
echo ""
echo "2. Update lib/main.dart to import firebase_options:"
echo "   Add: import 'firebase_options.dart';"
echo "   Update: await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);"
echo ""
echo "3. Enable services in Firebase Console:"
echo "   https://console.firebase.google.com"
echo "   - Authentication → Email/Password"
echo "   - Firestore Database → Test mode"
echo "   - Storage → Test mode"
echo ""
echo "4. Get dependencies and run:"
echo "   flutter pub get"
echo "   flutter run -d web-server --web-port 8080"
echo ""
echo "📖 See FIREBASE_INTEGRATION_SUMMARY.md for complete guide"
echo ""
