// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAawG2ydP6UoryaHDZdn4VfbfJfHvm7EsM',
    appId: '1:1085174490680:web:f4b2987f28c5e04b1368cd',
    messagingSenderId: '1085174490680',
    projectId: 'demoflutter-6021b',
    authDomain: 'demoflutter-6021b.firebaseapp.com',
    storageBucket: 'demoflutter-6021b.firebasestorage.app',
    measurementId: 'G-PY9R7E7FYC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZ4xKi6gg9xsM5ppyY1wOqGJHbKi3jgZ8',
    appId: '1:1085174490680:android:babfbc4b051b21ee1368cd',
    messagingSenderId: '1085174490680',
    projectId: 'demoflutter-6021b',
    storageBucket: 'demoflutter-6021b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDyobsZWBT5Ty3oK9oNnbSMlaGe-m66yc',
    appId: '1:1085174490680:ios:166a7eea6b58583e1368cd',
    messagingSenderId: '1085174490680',
    projectId: 'demoflutter-6021b',
    storageBucket: 'demoflutter-6021b.firebasestorage.app',
    iosBundleId: 'com.example.demoFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDyobsZWBT5Ty3oK9oNnbSMlaGe-m66yc',
    appId: '1:1085174490680:ios:166a7eea6b58583e1368cd',
    messagingSenderId: '1085174490680',
    projectId: 'demoflutter-6021b',
    storageBucket: 'demoflutter-6021b.firebasestorage.app',
    iosBundleId: 'com.example.demoFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAawG2ydP6UoryaHDZdn4VfbfJfHvm7EsM',
    appId: '1:1085174490680:web:3a4def1bb86bd1a01368cd',
    messagingSenderId: '1085174490680',
    projectId: 'demoflutter-6021b',
    authDomain: 'demoflutter-6021b.firebaseapp.com',
    storageBucket: 'demoflutter-6021b.firebasestorage.app',
    measurementId: 'G-KQ865QM34S',
  );

}