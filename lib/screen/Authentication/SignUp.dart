import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';
import 'package:rpskindisease/screen/Authentication/SignIn.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
import 'package:rpskindisease/widgets/Layout/InitialLayout.dart';
import 'package:rpskindisease/widgets/loader/custom_loader.dart';

class SignUpScreen extends StatefulWidget with ResponsiveLayoutMixin {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with ResponsiveLayoutMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void signUpUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return; // Prevent double-tap
    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Write user profile to Firestore (must succeed before we show success)
      try {
        await _firestore.collection('users').doc(uid).set({
          'userName': userNameController.text.trim(),
          'email': email,
          'mobile': mobileController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e, stackTrace) {
        debugPrint('Firestore write failed: $e');
        debugPrint('Stack: $stackTrace');
        rethrow;
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sign up successful!"),
      ));

      Get.off(() => SignInScreen());
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? "An error occurred"),
      ));
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? "Failed to save profile to Firestore"),
      ));
    } catch (e, stackTrace) {
      debugPrint('SignUp error: $e');
      debugPrint('Stack: $stackTrace');
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString().length > 80 ? "An error occurred" : e.toString()),
      ));
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email address can't be empty";
                      }
                      if (!_emailRegex.hasMatch(value.trim())) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
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
                  _isLoading
                      ? Center(child: CustomWaveLoader())
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
                          Get.to(() => SignInScreen());
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
