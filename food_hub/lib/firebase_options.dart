// PLACEHOLDER — буде замінено командою: flutterfire configure
// Виконай Крок 7 з інструкції firebase_setup.md
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw _notConfigured('web');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw _notConfigured('android');
      case TargetPlatform.iOS:
        throw _notConfigured('iOS');
      default:
        throw _notConfigured(defaultTargetPlatform.name);
    }
  }

  static UnsupportedError _notConfigured(String platform) =>
      UnsupportedError(
        '⚠️ Firebase not configured for $platform.\n'
        'Run: flutterfire configure',
      );
}
