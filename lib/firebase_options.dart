import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Placeholder Firebase options. Replace the string values with real keys from
/// your Firebase project (via `flutterfire configure`).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDx8glQQSg43Dqy2okQ4p3h5gTYIS7Fi48',
    appId: '1:341963901485:web:e48fc87d3287ed3b24c6a4',
    messagingSenderId: '341963901485',
    projectId: 'gogo-3055',
    authDomain: 'gogo-3055.firebaseapp.com',
    storageBucket: 'gogo-3055.firebasestorage.app',
    measurementId: 'G-FXR32YKV0J',
  );

  // ---- Web ----

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAc0MBg9_O3sK3vBl12WhijFFVs-Uu__BY',
    appId: '1:341963901485:android:fc18de9e0d8e404824c6a4',
    messagingSenderId: '341963901485',
    projectId: 'gogo-3055',
    storageBucket: 'gogo-3055.firebasestorage.app',
  );

  // ---- Android ----

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfunvA3xtQVQS5DVkSEe2XLGqgcXWU6SQ',
    appId: '1:341963901485:ios:1a2189e7f8e738fc24c6a4',
    messagingSenderId: '341963901485',
    projectId: 'gogo-3055',
    storageBucket: 'gogo-3055.firebasestorage.app',
    iosBundleId: 'com.example.gogoAppV2',
  );

  // ---- iOS ----

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBfunvA3xtQVQS5DVkSEe2XLGqgcXWU6SQ',
    appId: '1:341963901485:ios:1a2189e7f8e738fc24c6a4',
    messagingSenderId: '341963901485',
    projectId: 'gogo-3055',
    storageBucket: 'gogo-3055.firebasestorage.app',
    iosBundleId: 'com.example.gogoAppV2',
  );

  // ---- macOS ----

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDx8glQQSg43Dqy2okQ4p3h5gTYIS7Fi48',
    appId: '1:341963901485:web:97930dcbc389f52224c6a4',
    messagingSenderId: '341963901485',
    projectId: 'gogo-3055',
    authDomain: 'gogo-3055.firebaseapp.com',
    storageBucket: 'gogo-3055.firebasestorage.app',
    measurementId: 'G-8FRR5YTJLM',
  );

  // ---- Windows ----

  // ---- Linux ----
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: 'YOUR_LINUX_APP_ID',
    messagingSenderId: 'YOUR_LINUX_SENDER_ID',
    projectId: 'YOUR_LINUX_PROJECT_ID',
    storageBucket: 'YOUR_LINUX_STORAGE_BUCKET',
  );
}