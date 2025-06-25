import 'package:blood_donar/introduceApp/onbroadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Center(
              child: Lottie.asset('assets/injection.json'),
            )
          ],
        ), nextScreen: const OnboardingScreen(),
        duration: 1000,
        backgroundColor: Colors.white,
        );
  }
}
