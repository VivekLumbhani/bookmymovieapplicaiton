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
        return macos;
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
    apiKey: 'AIzaSyDzfRPm_VSrMqyefeY5aCLM6fPasDUK9t4',
    appId: '1:90385068552:web:e67927fdcad90958a357bd',
    messagingSenderId: '90385068552',
    projectId: 'bookmymovie-70dd7',
    authDomain: 'bookmymovie-70dd7.firebaseapp.com',
    databaseURL: 'https://bookmymovie-70dd7-default-rtdb.firebaseio.com',
    storageBucket: 'bookmymovie-70dd7.appspot.com',
    measurementId: 'G-3WNE6HDJM6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8AHaaDX0kv0ROS9NVqxC82Tb7pW5NXvY',
    appId: '1:90385068552:android:cee3e6b5e751b3c6a357bd',
    messagingSenderId: '90385068552',
    projectId: 'bookmymovie-70dd7',
    databaseURL: 'https://bookmymovie-70dd7-default-rtdb.firebaseio.com',
    storageBucket: 'bookmymovie-70dd7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3Q2mATEzDRDViTF7Wb7_p-hrD60unaP0',
    appId: '1:90385068552:ios:1747e3127812721aa357bd',
    messagingSenderId: '90385068552',
    projectId: 'bookmymovie-70dd7',
    databaseURL: 'https://bookmymovie-70dd7-default-rtdb.firebaseio.com',
    storageBucket: 'bookmymovie-70dd7.appspot.com',
    androidClientId: '90385068552-bhjeh4qscm3a63bk48apn1fraqort8co.apps.googleusercontent.com',
    iosClientId: '90385068552-jfca2npqvdb24fmlc5usl936qj46odan.apps.googleusercontent.com',
    iosBundleId: 'com.example.nookmyseatapplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3Q2mATEzDRDViTF7Wb7_p-hrD60unaP0',
    appId: '1:90385068552:ios:2975f6eb0d804d08a357bd',
    messagingSenderId: '90385068552',
    projectId: 'bookmymovie-70dd7',
    databaseURL: 'https://bookmymovie-70dd7-default-rtdb.firebaseio.com',
    storageBucket: 'bookmymovie-70dd7.appspot.com',
    androidClientId: '90385068552-bhjeh4qscm3a63bk48apn1fraqort8co.apps.googleusercontent.com',
    iosClientId: '90385068552-s7otf2qcg5ui8if0ddep5qi0u7vj3qjk.apps.googleusercontent.com',
    iosBundleId: 'com.example.nookmyseatapplication.RunnerTests',
  );
}
