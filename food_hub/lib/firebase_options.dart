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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqXdeG5e0BoGcb_tSk5n34_AnlhK3PGeQ',
    appId: '1:965239266366:android:ffd3503db619064bab856f',
    messagingSenderId: '965239266366',
    projectId: 'food-hub-2587c',
    storageBucket: 'food-hub-2587c.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDPDA6O2I4S0tUHupvd_dVT0Nej6WeT330',
    appId: '1:965239266366:web:78597bf8d415528dab856f',
    messagingSenderId: '965239266366',
    projectId: 'food-hub-2587c',
    authDomain: 'food-hub-2587c.firebaseapp.com',
    storageBucket: 'food-hub-2587c.firebasestorage.app',
    measurementId: 'G-RZSK29BT7V',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBRG5FyyF7BIAUGncguV7PW8fO2oH3WuNs',
    appId: '1:965239266366:ios:e30444c63deb9cbbab856f',
    messagingSenderId: '965239266366',
    projectId: 'food-hub-2587c',
    storageBucket: 'food-hub-2587c.firebasestorage.app',
    iosBundleId: 'com.example.foodHub',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRG5FyyF7BIAUGncguV7PW8fO2oH3WuNs',
    appId: '1:965239266366:ios:e30444c63deb9cbbab856f',
    messagingSenderId: '965239266366',
    projectId: 'food-hub-2587c',
    storageBucket: 'food-hub-2587c.firebasestorage.app',
    iosBundleId: 'com.example.foodHub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDPDA6O2I4S0tUHupvd_dVT0Nej6WeT330',
    appId: '1:965239266366:web:a552121604c23b06ab856f',
    messagingSenderId: '965239266366',
    projectId: 'food-hub-2587c',
    authDomain: 'food-hub-2587c.firebaseapp.com',
    storageBucket: 'food-hub-2587c.firebasestorage.app',
    measurementId: 'G-CBY9951BNQ',
  );

}