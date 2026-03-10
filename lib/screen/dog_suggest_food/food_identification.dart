// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rpskindisease/constants/shared_preferences.dart';
import 'package:rpskindisease/utils/log_util.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/Drop_Down/drop_down.dart';
import 'package:rpskindisease/widgets/LoadingButton/loading_button.dart';
import 'package:rpskindisease/widgets/snakbar/snakbar.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:rpskindisease/data/demo.dart';

class FoodIDentificationScreen extends StatefulWidget {
  final Map<String, dynamic> dogData; // Receive dog details

  const FoodIDentificationScreen({super.key, required this.dogData});

  @override
  State<FoodIDentificationScreen> createState() => _FoodIDentificationScreenState();
}

class _FoodIDentificationScreenState extends State<FoodIDentificationScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  var apiBaseUrl;
  bool _isLoading = false;
  String? identifiedFood = "";
  String? dogDisease;
  final _formKeypopup = GlobalKey<FormState>();
  String? seletedDisease;

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
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("config").doc("prediction").get();
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

  Future<void> _foodIdentificationApi() async {
    if (_image == null) {
      showTopSnackBar(context, "Please Upload the Image!", Colors.redAccent);
      return;
    }

    print(widget.dogData);

    setState(() {
      _isLoading = true;
    });

    if (useDemoData) {
      await Future.delayed(Duration(milliseconds: demoDelayMs));
      final Map<String, dynamic> responseData = demoFoodPredictResponse;
      String predictedClass = responseData["predicted_class"] ?? "Unknown";
      if (predictedClass == "Spam images") {
        showTopSnackBar(context, "Invalid Image Upload Correct Image", Colors.red);
      } else {
        identifiedFood = predictedClass;
        _foodPredictAllergy();
      }
      setState(() => _isLoading = false);
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/thanushan/food-predict"));
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _image!.path,
        filename: path.basename(_image!.path),
      ),
    );

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(responseBody);

      String predictedClass = responseData["predicted_class"] ?? "Unknown";
      printLog(predictedClass);
      if (predictedClass == "Spam images") {
        showTopSnackBar(context, "Invalid Image Upload Correct Image", Colors.red);

        printLog(predictedClass);
      } else {
        identifiedFood = predictedClass;
        _foodPredictAllergy();
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  //! API2

  Future<void> _foodPredictAllergy() async {
    if (_image == null) {
      showTopSnackBar(context, "Please Upload the Image!", Colors.redAccent);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (useDemoData) {
      await Future.delayed(Duration(milliseconds: demoDelayMs));
      final Map<String, dynamic> responseData = demoPredictAllergyResponse;
      String predictedClass = responseData["predicted_class"] ?? "Unknown";
      if (predictedClass == "Allergic Food") {
        showErrorPopup(context, "This is Allergic For dog");
      } else {
        String? storedDisease =
            await SharedPreferencesHelper.getString("local_storage_dog_disease");

        if (storedDisease == null || storedDisease.isEmpty || storedDisease == "") {
          ShowPlacesPopUp(context);
        } else {
          suggestFood(storedDisease);
        }
      }
      setState(() => _isLoading = false);
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/thanushan/predict_allergy"));
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _image!.path,
        filename: path.basename(_image!.path),
      ),
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("Image uploaded successfully: $responseBody");
      final Map<String, dynamic> responseData = jsonDecode(responseBody);
      String predictedClass = responseData["predicted_class"] ?? "Unknown";

      if (predictedClass == "Allergic Food") {
        showErrorPopup(context, "This is Allergic For dog");
      } else {
        String? storedDisease =
            await SharedPreferencesHelper.getString("local_storage_dog_disease");

        if (storedDisease!.isEmpty || storedDisease == "") {
          ShowPlacesPopUp(context);
        } else {
          suggestFood(storedDisease);
        }
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  //! Api3

  Future<void> suggestFood(String disease) async {
    // String? storedDisease =
    //     await SharedPreferencesHelper.getString("local_storage_dog_disease");
    final String secondApiUrl = "${apiBaseUrl}/thanushan/suggest-food";

    // printLog(disease);
    String namedDisease;

    if (disease == "Hypersensitivity Allergic") {
      namedDisease = "Hypersensitivity allergic dermatosis";
    } else if (disease == "Hypersensitivity Allergic Dermatosis") {
      namedDisease = "Hypersensitivity allergic dermatosis";
    } else if (disease == "Bacterial_dermatosis") {
      namedDisease = "Bacterial dermatosis";
    } else if (disease == "Bacterial_dermatosis") {
      namedDisease = "Bacterial dermatosis";
    } else if (disease == "Fungal_infections") {
      namedDisease = "Fungal infections";
    } else if (disease == "Fungal Infections") {
      namedDisease = "Fungal infections";
    } else {
      namedDisease = disease;
    }

    Map<String, dynamic> requestBody = {
      "breed": widget.dogData["breed"],
      "age": widget.dogData["age"],
      "weight": widget.dogData["weight"],
      "disease": namedDisease == "" || namedDisease.isEmpty ? seletedDisease : namedDisease,
      "food": identifiedFood
    };

    try {
      if (useDemoData) {
        await Future.delayed(Duration(milliseconds: demoDelayMs));
        showFoodSuggestionPopup(context, demoSuggestFoodResponse);
        return;
      }

      var response = await http.post(
        Uri.parse(secondApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print(" API call successful: ${response.body}");
        var responseData = jsonDecode(response.body);
        showFoodSuggestionPopup(context, responseData);
      } else {
        print("Second API call failed with status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error in second API call: $e");
    }
  }

  @override
  void initState() {
    getApiUrlFromFirestore();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Identification"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ColumnSpacer(0.3),
              LoadingButton(
                isLoading: _isLoading,
                onPressed: () {
                  _foodIdentificationApi();
                  // _uploadSkinDiseasePrediction();
                  // if (_formKey.currentState!.validate()) {
                  //   signInUser(context);
                  // }
                },
                label: 'Submit',
              )
            ],
          ),
        ),
      )),
    );
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
              Text('Choose an option', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  void showErrorPopup(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60, // Centered error icon
              ),
              SizedBox(height: 10),
              Text(
                "Warning",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ColumnSpacer(0.02),
              Text(
                "Food Type : ${identifiedFood.toString()}",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void ShowPlacesPopUp(BuildContext parentcontext) async {
    showDialog(
      context: parentcontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Show The Relative Places"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKeypopup,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDropdown(
                    autovalidate: true,
                    labelText: "Disease",
                    hintText: "Choose one",
                    items: const [
                      "Bacterial dermatosis",
                      "Fungal infections",
                      "Hypersensitivity allergic dermatosis",
                      "Healthy"
                    ],
                    value: seletedDisease,
                    onChanged: (newValue) {
                      setState(() {
                        seletedDisease = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Disease is Required";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKeypopup.currentState!.validate()) {
                  suggestFood(seletedDisease.toString());
                  // predictLocations();
                  popScreen(context);
                  // saveDogData(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showFoodSuggestionPopup(BuildContext context, Map<String, dynamic> responseData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(
                responseData["suitable"] ? Icons.check_circle_outline : Icons.error_outline,
                color: responseData["suitable"] ? Colors.green : Colors.red,
                size: 60, // Centered icon
              ),
              SizedBox(height: 10),
              Text(
                responseData["suitable"] ? "Suitable Food Found" : "Not Suitable",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Food: ${responseData["food"]}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                responseData["reason"],
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
