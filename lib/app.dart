import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/ui/login_screen.dart';
import 'features/applications/screens/track_application_screen.dart';
import 'features/company_setup/screens/company_setup_screen.dart';
import 'features/profile/ui/edit_profile_screen.dart';
import 'presentation/screens/splash/simple_splash_screen.dart';

class WazeetApp extends StatelessWidget {
  const WazeetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAZEET',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        EditProfileScreen.routeName: (_) => const EditProfileScreen(),
        TrackApplicationScreen.routeName: (_) => const TrackApplicationScreen(),
        '/company-setup': (_) => const CompanySetupScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
