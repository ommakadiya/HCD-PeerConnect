// GENERATED FILE — DO NOT EDIT MANUALLY
//
// Run `flutterfire configure` in the project root to regenerate this file
// with your actual Firebase project credentials.
//
// Steps:
//   1. Install FlutterFire CLI:
//        dart pub global activate flutterfire_cli
//   2. From the project root (d:\#Sem-6\HCD\PeerConnect), run:
//        flutterfire configure
//   3. Select your Firebase project (or create one at https://console.firebase.google.com)
//   4. This file will be overwritten with real values.
//
// ⚠️  The app WILL NOT build until this file is properly generated.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform. '
          'Please run flutterfire configure.',
        );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // TODO: Replace the placeholder values below with real ones from
  //       `flutterfire configure`. Until then the app will crash at startup.
  // ──────────────────────────────────────────────────────────────────────────

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.peerConnect',
  );
}
