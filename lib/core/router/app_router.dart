import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/otp_verification_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/company_setup/activities_screen.dart';
import '../../presentation/screens/company_setup/summary_screen.dart';
import '../../presentation/screens/trade_license/package_selection_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/company-setup/activities',
        name: 'company-setup-activities',
        builder: (context, state) => const ActivitiesScreen(),
      ),
      GoRoute(
        path: '/company-setup/summary',
        name: 'company-setup-summary',
        builder: (context, state) => const SummaryScreen(),
      ),
      GoRoute(
        path: '/trade-license/packages',
        name: 'trade-license-packages',
        builder: (context, state) => const PackageSelectionScreen(),
      ),
    ],
  );
}