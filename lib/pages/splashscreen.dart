import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nookmyseatapplication/pages/auth_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: LottieBuilder.asset('assets/Lottie/splashing.json',height: 400,
                width: 500,
              )

            )
          ],
        ),
      ),
      nextScreen: const AuthPage(),
      splashIconSize: 400,
      backgroundColor: Colors.red,
    );
  }
}
