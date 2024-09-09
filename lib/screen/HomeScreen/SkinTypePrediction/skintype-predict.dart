// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rpskindisease/screen/HomeScreen/DiseaseIdentification/disease-identification.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SkinTypePrediction extends StatefulWidget {
  @override
  _SkinTypePredictionState createState() => _SkinTypePredictionState();
}

class _SkinTypePredictionState extends State<SkinTypePrediction> {
  final List<String> questions = [
    'How does your skin feel after cleansing? ',
    'How often do you experience acne or breakouts? ',
    'How often does your skin feel greasy throughout the day?',
    'Does your skin flake or peel? ',
    'Do you experience redness or irritation? '
  ];

  final List<Map<String, String>> options = [
    {'A': 'Dry', 'B': 'Oily', 'C': 'Normal'},
    {'A': 'Rarely', 'B': 'Often', 'C': 'Sometimes'},
    {'A': 'Rarely', 'B': 'Often', 'C': 'Sometimes'},
    {'A': 'Yes', 'B': 'No', 'C': 'Occasionally'},
    {'A': 'Often', 'B': 'Rarely', 'C': 'Sometimes'}
  ];

  var skintype;
  var accuracy;
  var apiUrl;
  bool _isLoading = false;

  Future<Map<String, dynamic>?> getNestedDocumentData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("config")
          .doc("skintype")
          .get();
      // .collection(nestedCollectionId)
      // .doc(nestedDocumentId)
      // .get();

      if (snapshot.exists) {
        print("dataa>>");
        print(snapshot.data());
        var data = snapshot.data() as Map<String, dynamic>;
        print(data["url"]);
        setState(() {
          apiUrl = data["url"];
        });
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print('No data found');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> sendPostRequest(List<dynamic> dataList) async {
    // final String url =
    //     'https://3ac3-34-125-145-18.ngrok-free.app/predict'; // Replace with your API endpoint

    // Convert the list to JSON format
    Map<String, dynamic> body = {'answers': dataList};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        print(jsonResponse["predicted_skin_type"]);
        _showPopup(context, jsonResponse["predicted_skin_type"] ?? "Normal");
        print('Request was successful: ${response.body}');
      } else {
        // If the server did not return a 200 OK response, throw an exception
        print('Failed to send request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while sending request: $e');
    }
  }

  List<String> _selectedAnswers = List.filled(5, '');
  void _showPopup(BuildContext context, String skintype) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Skin Type '),
          content: Row(
            children: [
              Text(
                'Your Skin Type Is :',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${skintype}',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(DiseaseIdentification());
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getNestedDocumentData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Type  Prediction'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Card(
            color: authTextFormFillColor,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...options[index].entries.map((entry) {
                    return RadioListTile<String>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: _selectedAnswers[index],
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswers[index] = value!.toString();
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryButtonColor,
        onPressed: () {
          // Get.to(DiseaseIdentification());
          sendPostRequest(_selectedAnswers);
          // You can handle the submission of answers here
          print(_selectedAnswers);
          // _showPopup(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
