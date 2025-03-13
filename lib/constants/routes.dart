// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'dart:developer' as printLogs;

import 'package:rpskindisease/screen/Authentication/SignIn.dart';
import 'package:rpskindisease/screen/Authentication/SignUp.dart';
import 'package:rpskindisease/screen/BottomNavigation/BottomNavigationScreen.dart';
import 'package:rpskindisease/screen/Onboarding/on_boarding_screen.dart';

class ScreenRoutes {
  // static const String toSplashScreen = "toSplashScreen";
  static const String toOnboardingScreen = "toOnboardingScreen";
  static const String toSplashScreen = "toSplashScreen";
  static const String toSigninScreen = "toSigninScreen";
  static const String toSignUpScreen = "toSignUpScreen";
  static const String toBottomNavbar = "toBottomNavbar";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // var args = settings.arguments;

    printLogs.log("Navigating to screen -> ${settings.name}");

    switch (settings.name) {
      case ScreenRoutes.toOnboardingScreen:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(),
          settings: settings,
        );
      case ScreenRoutes.toSigninScreen:
        return MaterialPageRoute(
          builder: (_) => SignInScreen(),
          settings: settings,
        );
      case ScreenRoutes.toSignUpScreen:
        return MaterialPageRoute(
          builder: (_) => SignUpScreen(),
          settings: settings,
        );
      case ScreenRoutes.toBottomNavbar:
        return MaterialPageRoute(
          builder: (_) => BottomNavigationScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => SignInScreen(),
          settings: settings,
        );
    }
  }
}
