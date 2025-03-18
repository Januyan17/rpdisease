// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:rpskindisease/screen/HomeScreen/HomeScreen.dart';
import 'package:rpskindisease/screen/MedicineScreen/MedicineScreen.dart';
import 'package:rpskindisease/screen/ProfileScreen/ProfileScreen.dart';
import 'package:rpskindisease/screen/dog_skin_disease/dog_skin_disease_identification.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // Track the selected index manually

  final List<String> _tabs = ["Home", "Disease", "Profile"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreenPage(),
          DogSkinDiseaseIdentifyScreen(),
          // MedicineScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: _tabs[_selectedIndex],
        labels: _tabs,
        icons: const [
          Icons.home,
          Icons.medical_information,
          // Icons.medical_information,
          Icons.person
        ],
        tabSize: 50,
        tabBarHeight: 60,
        textStyle: const TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
        ),
        tabIconColor: Colors.blueGrey,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: primaryButtonColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int index) {
          setState(() {
            _selectedIndex = index; // Update selected index
            _tabController.index = index; // Change TabController index
          });
        },
      ),
    );
  }
}
