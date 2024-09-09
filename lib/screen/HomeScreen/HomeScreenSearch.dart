// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allItems = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grape',
    'Lemon',
    'Mango',
    'Orange',
    'Papaya',
    'Strawberry',
    'Watermelon'
  ];
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _allItems
          .where((item) =>
              item.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            filled: true,
            fillColor: authTextFormFillColor,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: textFieldBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: textFieldBorderColor),
            ),
            prefixIcon: Icon(Icons.search)),
        style: TextStyle(color: Colors.black, fontSize: 18.0),
        cursorColor: Colors.black,
      ),
      // body: ListView.builder(
      //   itemCount: _filteredItems.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(_filteredItems[index]),
      //     );
      //   },
      // ),
    );
  }
}
