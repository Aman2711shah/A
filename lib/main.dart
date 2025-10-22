import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/profile/data/user_repository.dart';
import 'features/profile/state/profile_controller.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    if (!kIsWeb) {
      // For mobile platforms (iOS, Android, macOS)
      await Firebase.initializeApp();
      debugPrint('✅ Firebase initialized successfully for mobile');
    } else {
      // For web platform
      // Note: After running 'flutterfire configure', import the generated file:
      // import 'firebase_options.dart';
      // Then use: await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // For now, try to initialize without options (will fail until configured)
      try {
        await Firebase.initializeApp();
        debugPrint('✅ Firebase initialized successfully for web');
      } catch (e) {
        debugPrint(
            '⚠️  Firebase not configured for web yet. Run: flutterfire configure');
        debugPrint('   Error: $e');
      }
    }
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
    debugPrint('   Make sure to run: flutterfire configure');
    debugPrint('   See FIREBASE_SETUP.md for detailed instructions');
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

  runApp(
    MultiProvider(
      providers: [
        Provider<IUserRepository>(
          create: (_) => UserRepository(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (context) =>
              ProfileController(context.read<IUserRepository>()),
        ),
      ],
      child: const WazeetApp(),
    ),
  );
}
