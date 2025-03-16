import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rpskindisease/constants/colors.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/constants/shared_preferences.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            color: const Color.fromARGB(255, 252, 223, 190),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Beatrice Colon',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            '24, Female',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ProfileInfoCard(icon: Icons.work, text: 'Product designer'),
          ProfileInfoCard(icon: Icons.location_on, text: 'Chennai area, India'),
          ProfileInfoCard(icon: Icons.directions_walk, text: '18 miles away'),
          GestureDetector(
              onTap: () {
                logoutUser();
                SharedPreferencesHelper.clearAll();
                moveToScreen(context, ScreenRoutes.toSigninScreen);
              },
              child: ProfileInfoCard(icon: Icons.logout_sharp, text: 'Logout')),
        ],
      ),
    );
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoCard({required this.icon, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
