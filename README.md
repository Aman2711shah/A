# WAZEET - Business Setup Platform for UAE

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android">
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS">
</div>

## 📱 Overview

WAZEET is a comprehensive native mobile application built with Flutter that serves as a business setup and trade license platform specifically designed for the UAE market. The app streamlines company formation, visa processing, trade license applications, and various business services to help entrepreneurs and businesses establish their presence in the United Arab Emirates.

## ✨ Features

### 🔐 Authentication System
- **User Registration & Login**: Secure authentication with email/password
- **Forgot Password**: Password recovery functionality
- **Profile Management**: Complete user profile with personal information

### 🏢 Company Formation
- **Multi-step Company Setup**: Guided workflow for company formation
- **Company Types**: Support for LLC, Free Zone, Branch Office, and Representative Office
- **Shareholder Management**: Add and manage multiple shareholders
- **Real-time Validation**: Form validation and error handling

### 📄 Trade License Management
- **License Applications**: Apply for various types of trade licenses
- **Application Tracking**: Monitor application status and progress
- **Document Management**: Upload and manage required documents
- **Status Updates**: Real-time notifications for application updates

### 🛂 Visa Processing
- **Employee Visas**: Process employment visas for staff
- **Multiple Visa Types**: Support for Employment, Investor, Dependent, and Visit visas
- **Application Tracking**: Monitor visa application progress
- **Document Requirements**: Clear guidance on required documents

### 📊 Dashboard & Analytics
- **Business Overview**: Comprehensive dashboard with key metrics
- **Application Status**: Track all pending and completed applications
- **Quick Actions**: Easy access to frequently used features
- **Notifications**: Real-time updates and alerts

### 🎨 Modern UI/UX
- **Material Design 3**: Latest Material Design principles
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Animations**: Engaging user experience with smooth transitions

## 🛠️ Technical Stack

### Frontend
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language for Flutter development
- **Material Design 3**: Modern UI design system

### State Management
- **Provider**: State management solution for Flutter
- **ChangeNotifier**: Reactive state updates

### Navigation
- **GoRouter**: Declarative routing for Flutter
- **Deep Linking**: Support for deep links and navigation

### Local Storage
- **Hive**: Lightweight and fast NoSQL database
- **SharedPreferences**: Simple key-value storage

### HTTP & API
- **Dio**: Powerful HTTP client for Dart
- **HTTP**: Standard HTTP package for API calls

### UI Components
- **Form Builder**: Advanced form handling and validation
- **Cached Network Image**: Efficient image loading and caching
- **Shimmer**: Loading placeholders for better UX

### Notifications
- **Flutter Local Notifications**: Local push notifications
- **Custom Notification Service**: Tailored notification management

## 📁 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── router/             # App routing configuration
│   ├── services/           # Core services (storage, notifications)
│   └── theme/              # App theming and styling
├── features/               # Feature-based modules
│   ├── auth/               # Authentication feature
│   │   ├── providers/      # Auth state management
│   │   └── screens/        # Auth UI screens
│   ├── dashboard/          # Dashboard feature
│   ├── company_formation/  # Company setup feature
│   ├── trade_license/      # Trade license feature
│   ├── visa_processing/    # Visa processing feature
│   ├── profile/            # User profile feature
│   └── splash/             # Splash screen
├── shared/                 # Shared components
│   └── widgets/            # Reusable UI widgets
└── main.dart               # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Xcode (for iOS development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/wazeet.git
   cd wazeet
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-specific Setup

#### Android
- Minimum SDK version: 21 (Android 5.0)
- Target SDK version: 34 (Android 14)
- Permissions: Camera, Storage, Internet, Notifications

#### iOS
- Minimum iOS version: 11.0
- Target iOS version: 17.0
- Permissions: Camera, Photo Library, Notifications

## 📱 Screenshots

<div align="center">
  <img src="assets/screenshots/login.png" width="200" alt="Login Screen">
  <img src="assets/screenshots/dashboard.png" width="200" alt="Dashboard">
  <img src="assets/screenshots/company-formation.png" width="200" alt="Company Formation">
  <img src="assets/screenshots/trade-license.png" width="200" alt="Trade License">
</div>

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
API_BASE_URL=https://api.wazeet.com
API_KEY=your_api_key_here
```

### Firebase Setup (Optional)
For push notifications and analytics:
1. Create a Firebase project
2. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
3. Configure Firebase services

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write unit tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Email: support@wazeet.com
- Documentation: [docs.wazeet.com](https://docs.wazeet.com)
- Issues: [GitHub Issues](https://github.com/yourusername/wazeet/issues)

## 🗺️ Roadmap

### Version 2.0
- [ ] Real-time chat support
- [ ] Document scanning with OCR
- [ ] Multi-language support (Arabic, Hindi, Urdu)
- [ ] Advanced analytics dashboard
- [ ] Integration with UAE government portals

### Version 2.1
- [ ] AI-powered business recommendations
- [ ] Blockchain-based document verification
- [ ] Advanced reporting features
- [ ] White-label solutions

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- UAE government for business-friendly policies
- Our beta testers and early adopters

---

<div align="center">
  <p>Made with ❤️ for the UAE business community</p>
  <p>© 2024 WAZEET. All rights reserved.</p>
</div>
