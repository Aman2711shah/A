# WAZEET Flutter App Setup Instructions

## Prerequisites

1. **Flutter SDK**: Install Flutter SDK (version 3.0.0 or higher)
   ```bash
   # Download from https://flutter.dev/docs/get-started/install
   # Or use package manager like Homebrew on macOS:
   brew install flutter
   ```

2. **Dart SDK**: Comes with Flutter installation

3. **Android Studio / VS Code**: For development

4. **Android SDK**: For Android development
5. **Xcode**: For iOS development (macOS only)

## Project Setup

### 1. Clone and Navigate to Project
```bash
cd /Users/amanshah/Documents/GitHub/A
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
```bash
# Generate JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes during development
flutter pub run build_runner watch
```

### 4. Run the App
```bash
# Run on Android
flutter run

# Run on iOS (macOS only)
flutter run

# Run with specific device
flutter devices
flutter run -d <device_id>
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Main app widget
├── config/                      # Configuration files
│   ├── routes/                  # App routing
│   ├── theme/                   # App theming
│   └── constants/               # App constants
├── core/                        # Core functionality
│   ├── network/                 # Network layer
│   ├── storage/                 # Storage layer
│   └── utils/                   # Utility functions
├── data/                        # Data layer
│   ├── models/                  # Data models
│   └── repositories/            # Repository implementations
├── presentation/                # Presentation layer
│   ├── blocs/                   # BLoC state management
│   ├── screens/                 # UI screens
│   └── widgets/                 # Reusable widgets
└── injection_container.dart     # Dependency injection
```

## Key Features Implemented

### ✅ Authentication System
- Login with email/password
- Registration with OTP verification
- Biometric authentication
- Secure token storage

### ✅ Company Setup Flow
- Business activities selection
- Shareholder management
- Visa requirements
- Cost calculation
- Setup summary

### ✅ Trade License Application
- Package selection
- Document upload
- Application tracking
- Progress stepper

### ✅ UI Components
- Custom buttons and text fields
- Progress steppers
- Package cards
- Loading indicators
- Responsive design

### ✅ State Management
- BLoC pattern implementation
- Event-driven architecture
- State management for auth and company setup

### ✅ Network Layer
- Dio HTTP client
- API interceptors
- Token refresh handling
- Error handling

### ✅ Storage
- Secure storage for tokens
- Local storage for drafts
- Hive database integration

## Configuration

### API Configuration
Update `lib/config/constants/api_constants.dart` with your API endpoints:

```dart
class ApiConstants {
  static const String baseUrl = 'https://your-api-url.com/v1';
  // ... other endpoints
}
```

### Firebase Setup (Optional)
1. Create Firebase project
2. Add configuration files:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
3. Update Firebase configuration in `main.dart`

## Build and Deploy

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS app
flutter build ios --release
```

## Development Commands

```bash
# Clean build
flutter clean
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

## Troubleshooting

### Common Issues

1. **Build Runner Issues**
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner clean
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Dependencies Issues**
   ```bash
   flutter pub deps
   flutter pub upgrade
   ```

3. **Android Build Issues**
   - Ensure Android SDK is installed
   - Check Android license acceptance: `flutter doctor --android-licenses`

4. **iOS Build Issues**
   - Ensure Xcode is installed
   - Run `pod install` in `ios/` directory

## Next Steps

1. **Add API Integration**: Connect to real WAZEET API endpoints
2. **Implement Payment**: Add Stripe/PayTabs integration
3. **Add Push Notifications**: Firebase Cloud Messaging
4. **Add Document Scanner**: ML Kit integration
5. **Add Maps**: Google Maps for free zone locations
6. **Add Localization**: Arabic RTL support
7. **Add Testing**: Unit and integration tests
8. **Add CI/CD**: Automated build and deployment

## Support

For issues and questions, please refer to the Flutter documentation or contact the development team.
