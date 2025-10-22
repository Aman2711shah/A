import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase only if not on web or if properly configured
    if (!kIsWeb) {
      await Firebase.initializeApp();
    } else {
      // For web, we need Firebase configuration
      // For now, we'll skip Firebase on web
      print('Running on web - Firebase disabled');
    }
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  // Initialize Hive
  await Hive.initFlutter();

  // Setup dependency injection
  await di.init();

  // Set preferred orientations (only on mobile)
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style (only on mobile)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  runApp(const WazeetApp());
}
