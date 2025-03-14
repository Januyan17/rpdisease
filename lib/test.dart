// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
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

  Future<void> _uploadImage() async {
    if (_image == null) {
      showTopSnackBar(context, "Please Upload the Image!", Colors.redAccent);
      return;
    }
    if (_factorsControllers.text == null ||
        _factorsControllers.text.isEmpty ||
        _factorsControllers.text.trim().isEmpty) {
      showTopSnackBar(context, "Please Add Symptoms", Colors.redAccent);
      return;
    }
    setState(() {
      _isLoading = true;
    });

    var request =
        http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/predict-text"));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        filename: path.basename(_image!.path),
      ),
    );
    request.fields['symptoms'] = _factorsControllers.text.trim();

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("Image uploaded successfully: $responseBody");
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
    }

    setState(() {
      _isLoading = false;
    });
  }

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
      appBar: AppBar(
        title: Text("Skin Disease Prediction"),
      ),
      body: SingleChildScrollView(
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
              _image != null
                  ? CustomTextFormField(
                      maxLines: 4,
                      hintText: "Symptoms Of  Dog ",
                      controller: _factorsControllers,
                      labelText: "Symptoms",
                      obscure: false)
                  : SizedBox.shrink(),
              ColumnSpacer(0.03),
              _image != null
                  ? LoadingButton(
                      isLoading: _isLoading,
                      onPressed: () {
                        _uploadImage();
                        // if (_formKey.currentState!.validate()) {
                        //   signInUser(context);
                        // }
                      },
                      label: 'SignIn',
                    )
                  : SizedBox(),

              // CustomElevatedButton(
              //     onPressed: _uploadImage,
              //     label: 'Continue',
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
