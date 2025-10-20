import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
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
      home: const SplashScreen(),
    );
  }
}
