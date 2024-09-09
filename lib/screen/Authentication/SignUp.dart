import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';
import 'package:rpskindisease/screen/Authentication/SignIn.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
import 'package:rpskindisease/widgets/Layout/InitialLayout.dart';

class SignUpScreen extends StatelessWidget with ResponsiveLayoutMixin {
  SignUpScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void signUpUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Set loading to true
        isLoading = true;

        // Create user with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Add user information to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'userName': userNameController.text.trim(),
          'email': emailController.text.trim(),
          'mobile': mobileController.text.trim(),
          'createdAt': DateTime.now(),
        });
        // Set loading to false
        isLoading = false;

        // Navigate to the home screen or show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Sign up successful!"),
        ));

        Get.to(SignInScreen());
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Auth exceptions
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? "An error occurred"),
        ));
      } catch (e) {
        // Handle other exceptions
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("An error occurred"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InitialLayout(body: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up",
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
                    prefixIcon: Icons.person,
                    obscure: false,
                    controller: userNameController,
                    labelText: 'User Name ',
                    validator: (value) =>
                        value!.isEmpty ? "User Name can't be empty" : null,
                  ),
                  SizedBox(height: getScreenHeight(context) * 0.02),
                  CustomTextFormField(
                    prefixIcon: Icons.mobile_friendly,
                    obscure: false,
                    controller: mobileController,
                    labelText: 'Mobile Number ',
                    validator: (value) =>
                        value!.isEmpty ? " Mobile Number can't be empty" : null,
                  ),
                  SizedBox(height: getScreenHeight(context) * 0.02),
                  CustomTextFormField(
                    prefixIcon: Icons.email,
                    obscure: false,
                    controller: emailController,
                    labelText: 'Email address',
                    validator: (value) =>
                        value!.isEmpty ? "Email address can't be empty" : null,
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
                      ? Center(child: CircularProgressIndicator())
                      : CustomElevatedButton(
                          onPressed: () => signUpUser(context),
                          label: 'Sign Up',
                        ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Already Have an Account?"),
                      SizedBox(
                        width: getScreenHeight(context) * 0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(SignInScreen());
                        },
                        child: Text(
                          "Sign In",
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
    ]);
  }
}
