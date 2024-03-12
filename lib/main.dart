import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nookmyseatapplication/pages/splashscreen.dart';
import 'package:nookmyseatapplication/pages/themes/theme_model.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // Import Provider

void main() async {
  await AwesomeNotifications().initialize(
    null, // credentials for push notifications (optional)
    [
      NotificationChannel(
        channelKey: 'timer_channel', // Unique key for the channel
        channelName: 'Timer Notifications', // User-visible name
        channelDescription: 'Notifications for timers set in the app', // Description for the user
        importance: NotificationImportance.High, // Importance level (optional)
        playSound: true, // Play a sound (optional)
        enableVibration: true, // Vibrate the device (optional)
      ),
    ],
    debug: true, // Set to false for production builds
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel()),
        // Add other providers as needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
