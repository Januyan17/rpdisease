import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rpskindisease/screen/Onboarding/on_boarding_screen.dart';
import 'package:rpskindisease/constants/routes.dart' as routes;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding, user: user));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  final User? user;

  const MyApp({super.key, required this.hasSeenOnboarding, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routes.Router.generateRoute,
      initialRoute: hasSeenOnboarding
          ? (user != null
              ? routes.ScreenRoutes.toBottomNavbar
              : routes.ScreenRoutes.toSigninScreen)
          : routes.ScreenRoutes.toOnboardingScreen,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.orangeAccent.shade200),
        useMaterial3: true,
      ),
      home: OnboardingScreen(),
    );
  }
}
