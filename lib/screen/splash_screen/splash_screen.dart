// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;
      User? user = FirebaseAuth.instance.currentUser;
      // moveToScreen(context, ScreenRoutes.toBottomNavbar);
      // code to be executed after 2 seconds
      if (!hasSeenOnboarding) {
        moveToScreen(context, ScreenRoutes.toOnboardingScreen);
        // Navigator.pushReplacementNamed(context, routes.ScreenRoutes.toOnboardingScreen);
      } else if (user == null) {
        moveToScreen(context, ScreenRoutes.toSigninScreen);
      } else {
        moveToScreen(context, ScreenRoutes.toBottomNavbar);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Welcome to"),
            // ColumnSpacer(0.05),
            Lottie.asset(
              'assets/images/dog2.json',
              // width: 150,
              // height: 150,
              // fit: BoxFit.cover,
            ),
          ],
        ),
      )),
    );
  }
}
