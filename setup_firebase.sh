#!/bin/bash

# WAZEET Firebase Setup Script
# This script will help you set up Firebase for your Flutter app

echo "🔥 WAZEET Firebase Setup Script"
echo "================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "⚠️  Firebase CLI not found."
    echo "Installing Firebase CLI..."
    echo "Please run: npm install -g firebase-tools"
    echo "Or visit: https://firebase.google.com/docs/cli"
    echo ""
fi

# Install FlutterFire CLI
echo "📦 Installing FlutterFire CLI..."
dart pub global activate flutterfire_cli

# Add to PATH if not already there
export PATH="$PATH":"$HOME/.pub-cache/bin"

echo ""
echo "✅ FlutterFire CLI installed"
echo ""

# Check if user is logged in to Firebase
echo "🔐 Checking Firebase authentication..."
firebase login --status 2>/dev/null || {
    echo "⚠️  Not logged in to Firebase"
    echo "Please run: firebase login"
    echo ""
}

echo ""
echo "📋 Next Steps:"
echo "1. Make sure you're logged in to Firebase: firebase login"
echo "2. Run: flutterfire configure"
echo "3. Select your Firebase project or create a new one"
echo "4. Select platforms: iOS, Android, Web, macOS"
echo "5. Follow the setup guide in FIREBASE_SETUP.md"
echo ""
echo "🚀 After configuration, run: flutter pub get"
echo ""
