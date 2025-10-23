import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for all supported platforms.
///
/// Generated manually using values from the provided
/// `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase options have not been configured for web. '
        'Run flutterfire configure or update firebase_options.dart accordingly.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFsXhPEEpDvo1T9iguBVG7aCVRNCWLfgs',
    appId: '1:610092962291:android:d29e933a892f4b72080286',
    messagingSenderId: '610092962291',
    projectId: 'aaaa-8ed0c',
    storageBucket: 'aaaa-8ed0c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-NzArkPVfSfMGRGEvsNutFrwi5KDVF-E',
    appId: '1:610092962291:ios:b1aa18b3d282f34f080286',
    messagingSenderId: '610092962291',
    projectId: 'aaaa-8ed0c',
    storageBucket: 'aaaa-8ed0c.firebasestorage.app',
    iosBundleId: 'com.wazeet.app',
  );
}
