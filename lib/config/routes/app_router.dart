import 'package:flutter/material.dart';
import 'route_names.dart';
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
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        
      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
        
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
        
      case RouteNames.otpVerification:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phone: args['phone']),
        );
        
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
        
      case RouteNames.activities:
        return MaterialPageRoute(builder: (_) => const ActivitiesScreen());
        
      case RouteNames.setupSummary:
        return MaterialPageRoute(builder: (_) => const SummaryScreen());
        
      case RouteNames.packageSelection:
        return MaterialPageRoute(builder: (_) => const PackageSelectionScreen());
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}