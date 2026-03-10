// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/screen/Authentication/SignUp.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/Layout/InitialLayout.dart';
import 'package:rpskindisease/widgets/LoadingButton/loading_button.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Method to handle user sign-in
  Future<void> signInUser(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });
      // Get.to(BottomNavigationScreen());
      moveToScreen(context, ScreenRoutes.toBottomNavbar);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
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
            ColumnSpacer(0.05),
            Image.asset("assets/images/login.png"),
            // SizedBox(
            //   height: ScreenUtils.height * 0.3,
            //   width: ScreenUtils.width,
            //   child: Image.asset("assets/images/login.png"),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      autovalidate: true,
                      prefixIcon: Icons.email,
                      obscure: false,
                      controller: emailController,
                      labelText: 'Email address',
                      validator: (value) => value!.isEmpty
                          ? "Email address can't be empty"
                          : null,
                    ),
                    // SizedBox(height: getScreenHeight(context) * 0.02),
                    ColumnSpacer(0.02),
                    CustomTextFormField(
                      autovalidate: true,
                      prefixIcon: Icons.password,
                      obscure: true,
                      controller: passwordController,
                      labelText: 'Password',
                      validator: (value) =>
                          value!.isEmpty ? "Password can't be empty" : null,
                    ),
                    // SizedBox(height: getScreenHeight(context) * 0.01),
                    ColumnSpacer(0.01),
                    Align(
                        alignment: Alignment.topRight,
                        child: Text("Forget Password?")),
                    // SizedBox(height: getScreenHeight(context) * 0.05),
                    ColumnSpacer(0.05),
                    LoadingButton(
                      isLoading: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signInUser(context);
                        }
                      },
                      label: 'SignIn',
                    ),

                    ColumnSpacer(0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Don't Have an Account ?"),
                        RowSpacer(0.02),
                        // SizedBox(
                        //   width: getScreenHeight(context) * 0.02,
                        // ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignUpScreen());
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
