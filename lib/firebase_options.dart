// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAgY5FDndHEtAp1mmE523ILHag0gQBokt8',
    appId: '1:451550246287:web:f742a064226dd8708087fa',
    messagingSenderId: '451550246287',
    projectId: 'instagram-c201f',
    authDomain: 'instagram-c201f.firebaseapp.com',
    storageBucket: 'instagram-c201f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAV-YyFxCEJmgd9JQn9DPjhHbXiPU4nLxY',
    appId: '1:451550246287:android:7dd831c16158c6c48087fa',
    messagingSenderId: '451550246287',
    projectId: 'instagram-c201f',
    storageBucket: 'instagram-c201f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhsbXfJghIK7OPN6MBwCy0D5TyA2cX8Sc',
    appId: '1:451550246287:ios:559fdfddcabb698d8087fa',
    messagingSenderId: '451550246287',
    projectId: 'instagram-c201f',
    storageBucket: 'instagram-c201f.appspot.com',
    iosClientId: '451550246287-qmrg0d95ai7nfphn6fi796guqd922avh.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramClone',
  );
}
