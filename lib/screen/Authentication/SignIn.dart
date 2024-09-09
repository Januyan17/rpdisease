// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';
import 'package:rpskindisease/screen/Authentication/SignUp.dart';
import 'package:rpskindisease/screen/BottomNavigation/BottomNavigationScreen.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
import 'package:rpskindisease/widgets/Layout/InitialLayout.dart';

class SignInScreen extends StatelessWidget with ResponsiveLayoutMixin {
  SignInScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var isLoading = false;

  // Method to handle user sign-in
  Future<void> signInUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading = true; // Show loading indicator
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        isLoading = false; // Hide loading indicator
        Get.to(BottomNavigationScreen()); // Navigate to the next screen
      } on FirebaseAuthException catch (e) {
        isLoading = false; // Hide loading indicator
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage = e.message!;
        }
        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InitialLayout(
      backgroundColor: primaryBackgroundColor,
      body: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SignIn",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: getScreenHeight(context) * 0.05,
            ),
            SizedBox(
              height: getScreenHeight(context) * 0.3,
              width: getScreenWidth(context),
              child: Image.asset("assets/images/login.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      prefixIcon: Icons.email,
                      obscure: false,
                      controller: emailController,
                      labelText: 'Email address',
                      validator: (value) => value!.isEmpty
                          ? "Email address can't be empty"
                          : null,
                    ),
                    SizedBox(height: getScreenHeight(context) * 0.02),
                    CustomTextFormField(
                      prefixIcon: Icons.password,
                      obscure: true,
                      controller: passwordController,
                      labelText: 'Password',
                      validator: (value) =>
                          value!.isEmpty ? "Password can't be empty" : null,
                    ),
                    SizedBox(height: getScreenHeight(context) * 0.01),
                    Align(
                        alignment: Alignment.topRight,
                        child: Text("Forget Password?")),
                    SizedBox(height: getScreenHeight(context) * 0.05),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            value: 10,
                          ))
                        : CustomElevatedButton(
                            onPressed: () => signInUser(context),
                            label: 'SignIn',
                          ),
                    SizedBox(
                      height: getScreenHeight(context) * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Don't Have an Account ?"),
                        SizedBox(
                          width: getScreenHeight(context) * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(SignUpScreen());
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
