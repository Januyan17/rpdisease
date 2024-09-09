// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:rpskindisease/screen/HomeScreen/HomeScreen.dart';
import 'package:rpskindisease/screen/MedicineScreen/MedicineScreen.dart';
import 'package:rpskindisease/screen/ProfileScreen/ProfileScreen.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          HomeScreenPage(),
          MedicineScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Home", "Stages", "Profile"],
        icons: const [Icons.home, Icons.medical_information, Icons.person],
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
            _tabController!.index = index;
          });
        },
      ),
    );
  }
}
