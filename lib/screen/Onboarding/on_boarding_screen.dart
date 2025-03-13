import 'package:flutter/material.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    moveToScreen(context, ScreenRoutes.toSigninScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 2);
              },
              children: [
                buildPage(
                  title: "Identify Dog Diseases",
                  description:
                      "Scan and identify common dog diseases using AI.",
                  image: "assets/images/login.png",
                ),
                buildPage(
                  title: "Get Instant Reports",
                  description: "Receive quick health reports for your pet.",
                  image: "assets/images/login.png",
                ),
                buildPage(
                  title: "Get Started",
                  description: "Start diagnosing your pet’s health now!",
                  image: "assets/images/login.png",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _controller.jumpToPage(2),
                  child: Text("Skip"),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(dotHeight: 8, dotWidth: 8),
                ),
                isLastPage
                    ? TextButton(
                        onPressed: () {
                          moveToScreen(context, ScreenRoutes.toSigninScreen);
                          completeOnboarding();
                        },
                        child: Text("Get Started"),
                      )
                    : TextButton(
                        onPressed: () => _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        ),
                        child: Text("Next"),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(
      {required String title,
      required String description,
      required String image}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          SizedBox(height: 20),
          Text(title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(description,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
