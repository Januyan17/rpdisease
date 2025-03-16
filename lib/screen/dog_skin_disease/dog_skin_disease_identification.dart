// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:rpskindisease/constants/colors.dart';
import 'package:rpskindisease/screen/dog_medicine_suggestion/dog_medicine_suggest.dart';
import 'package:rpskindisease/utils/spacers/screen_size_calculator.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpskindisease/widgets/LoadingButton/loading_button.dart';
import 'package:rpskindisease/widgets/snakbar/snakbar.dart';

class DogSkinDiseaseIdentifyScreen extends StatefulWidget {
  const DogSkinDiseaseIdentifyScreen({super.key});

  @override
  State<DogSkinDiseaseIdentifyScreen> createState() =>
      _DogSkinDiseaseIdentifyScreenState();
}

class _DogSkinDiseaseIdentifyScreenState
    extends State<DogSkinDiseaseIdentifyScreen> {
  TextEditingController _factorsControllers = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  var apiBaseUrl;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> getApiUrlFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("config")
          .doc("prediction")
          .get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          apiBaseUrl = data["url"];
        });
      }
    } catch (e) {
      print('Error fetching API URL: $e');
    }
  }

//! Upload Image as Base64 Format
  Future<void> _uploadSkinDiseasePrediction() async {
    if (_image == null) {
      showTopSnackBar(context, "Please Upload the Image!", Colors.redAccent);
      return;
    }
    if (_factorsControllers.text.trim().isEmpty) {
      showTopSnackBar(context, "Please Add Symptoms", Colors.redAccent);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert image to Base64
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // printLog(base64Image);

      // Prepare request body
      Map<String, dynamic> requestBody = {
        "image": base64Image,
        "symptoms": _factorsControllers.text.trim(),
      };

      var response = await http.post(
        Uri.parse("$apiBaseUrl/predict-text"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Image uploaded successfully: ${response.body}");
      } else {
        print("Failed to upload image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> _uploadImage() async {
  //   if (_image == null) {
  //     showTopSnackBar(context, "Please Upload the Image!", Colors.redAccent);
  //     return;
  //   }
  //   if (_factorsControllers.text == null ||
  //       _factorsControllers.text.isEmpty ||
  //       _factorsControllers.text.trim().isEmpty) {
  //     showTopSnackBar(context, "Please Add Symptoms", Colors.redAccent);
  //     return;
  //   }
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   var request =
  //       http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/predict-text"));
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       'image',
  //       _image!.path,
  //       filename: path.basename(_image!.path),
  //     ),
  //   );
  //   request.fields['symptoms'] = _factorsControllers.text.trim();

  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     final responseBody = await response.stream.bytesToString();
  //     print("Image uploaded successfully: $responseBody");
  //   } else {
  //     print("Failed to upload image. Status code: ${response.statusCode}");
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Choose an option',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Select from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getApiUrlFromFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text("Skin Disease Prediction"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Tap to Select Image"),
                                  SizedBox(height: 10),
                                  Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: _removeImage,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                ColumnSpacer(0.03),
                CustomTextFormField(
                    maxLines: 4,
                    hintText: "Symptoms Of  Dog ",
                    controller: _factorsControllers,
                    labelText: "Symptoms",
                    obscure: false),

                ColumnSpacer(0.03),
                LoadingButton(
                  isLoading: _isLoading,
                  onPressed: () {
                    // _uploadSkinDiseasePrediction();
                    _showPickerDialogOption();
                    // if (_formKey.currentState!.validate()) {
                    //   signInUser(context);
                    // }
                  },
                  label: 'Submit',
                )

                // CustomElevatedButton(
                //     onPressed: _uploadImage,
                //     label: 'Continue',
                //   )
              ],
            ),
          ),
        ),
      ),
    );
  }

//! Go to Mikki or Jumpu POP up

  void _showPickerDialogOption() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Select Option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.medical_information_outlined),
              title: Text("Suggest Medicine"),
              onTap: () {
                Navigator.pop(dialogContext);

                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) {
                    showDogSelectionPopup(context);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.food_bank_outlined),
              title: const Text("Suggest Food"),
              onTap: () {
                // Close the current dialog first
                Navigator.pop(dialogContext);

                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) {
                    // _showPickerDialog();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  //mikki Popup1

  //! Mikki API

  void showDogSelectionPopup(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    QuerySnapshot snapshot = await firestore
        .collection("users")
        .doc(user.uid)
        .collection("dogs")
        .get();

    List<Map<String, dynamic>> dogs = snapshot.docs
        .map((doc) => {"id": doc.id, "name": doc["name"]})
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use dialogContext
        return AlertDialog(
          title: Text("Select Your Dog"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: dogs.map((dog) {
              return ListTile(
                title: Text(dog["name"]),
                onTap: () {
                  // Close the dialog before making API calls
                  Navigator.pop(dialogContext);

                  // Ensure widget is still mounted before navigation
                  Future.delayed(Duration(milliseconds: 300), () {
                    if (mounted) {
                      fetchDogDetailsAndNavigate(context, dog["id"]);
                    }
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void fetchDogDetailsAndNavigate(BuildContext context, String dogId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    DocumentSnapshot doc = await firestore
        .collection("users")
        .doc(user.uid)
        .collection("dogs")
        .doc(dogId)
        .get();

    if (doc.exists) {
      Map<String, dynamic> dogData = doc.data() as Map<String, dynamic>;
      dogData["id"] = doc.id; // Include the document ID

      // Navigate to the next page with the dog's details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DogMediceSuggestion(dogData: dogData),
        ),
      );
    } else {
      showTopSnackBar(context, "Dog not found!", Colors.redAccent);
    }
  }
}
