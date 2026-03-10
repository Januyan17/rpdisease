// ignore_for_file: depend_on_referenced_packages, unused_field

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rpskindisease/constants/api.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/data/demo.dart';
import 'package:rpskindisease/constants/shared_preferences.dart';
import 'package:rpskindisease/utils/log_util.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:rpskindisease/utils/parameters.dart';
import 'package:rpskindisease/utils/spacers/screen_size_calculator.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/Drop_Down/drop_down.dart';
import 'package:rpskindisease/widgets/containers/custom_dog_widget.dart';
import 'package:rpskindisease/screen/dog_detail/dog_detail_screen.dart';
import 'package:rpskindisease/widgets/loader/custom_loader.dart';
import 'package:rpskindisease/widgets/snakbar/snakbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class DogSwipeScreen extends StatefulWidget {
  const DogSwipeScreen({Key? key}) : super(key: key);

  @override
  _DogSwipeScreenState createState() => _DogSwipeScreenState();
}

class _DogSwipeScreenState extends State<DogSwipeScreen> {
  List<Map<String, dynamic>> dogs = [];
  String? userId;
  File? _image;
  File? _selectedAudioFile;
  var apiBaseUrl;
  bool _isLoading = false;
  String? genderSelectedValue;
  final _formKey = GlobalKey<FormState>();
  final _formKeyUpdate = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserAndFetchDogs();
    getApiUrlFromFirestore();
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

  Future<void> getUserAndFetchDogs() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
        await fetchDogs(user.uid);
      }
    } catch (e) {
      print("Error getting user: $e");
    }
  }

  Future<void> fetchDogs(String userId) async {
    if (useDemoData) {
      await Future.delayed(Duration(milliseconds: demoDelayMs));
      setState(() {
        dogs = demoDogsList;
      });
      return;
    }
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("dogs")
          .get();
      List<Map<String, dynamic>> tempDogs = snapshot.docs
          .map((doc) => {
                "name": doc["name"],
                "image": doc["image"],
                "breed": doc["breed"],
                "age": doc["age"],
                "weight": doc["weight"],
                "gender": doc["gender"],
                "id": doc.id
              })
          .toList();

      setState(() {
        dogs = tempDogs;
      });
    } catch (e) {
      print("Error fetching dogs: $e");
      if (useDemoData) {
        setState(() => dogs = demoDogsList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtils.height * 0.25,
      width: ScreenUtils.width,
      child: userId == null
          ? Center(child: CustomWaveLoader())
          : dogs.isEmpty
              ? Center(child: CustomWaveLoader())
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dogs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == dogs.length) {
                      // The additional container with a button
                      return Container(
                        height: ScreenUtils.height * 0.25,
                        width: ScreenUtils.height * 0.2,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkSWrzIwJRAcr1EewL4Tx7T1draCqhxbed0A&s"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              //Janu
                              _showPickerDialogOption();
                              // Handle button press
                              // showAddDogPopup(context);
                            },
                            child: Text("+ Add Your Pet"),
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (context) => DogDetailScreen(
                              dogData: Map<String, dynamic>.from(dogs[index]),
                            ),
                          ),
                        );
                        if (result == true && userId != null) {
                          await fetchDogs(userId!);
                        }
                      },
                      onLongPress: () {
                        showDeleteConfirmationDialog(
                            context, dogs[index]["id"]);
                      },
                      child: CustomDogCardWidget(
                        imagePath: dogs[index]["image"],
                        title: dogs[index]["name"],
                        subtitle: dogs[index]["breed"],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                ),
    );
  }

//* Pick Audio File
  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['m4a', 'mp3', 'mp4'],
    );
    if (result != null) {
      setState(() {
        _selectedAudioFile = File(result.files.single.path!);
      });
      _apiUploadAudioFile();
    }
  }

  //* Pick Image File
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      printLog("Breed : Image is :><><><> ${_image!.path}");
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      _apiUploadImageFile();
      // showAddDogPopup(context);
    });
    Navigator.pop(context);
  }

  //! API CALL FOR Upload By Voice
  Future<void> _apiUploadAudioFile() async {
    if (_selectedAudioFile == null) return;

    if (useDemoData) {
      await Future.delayed(Duration(milliseconds: demoDelayMs));
      final Map<String, dynamic> responseData = demoPredictWithVoiceResponse;
      String breed = responseData["predicted_breed"] ?? "Labrador Retriever";
      await SharedPreferencesHelper.setString("local_storage_dog_breed", breed);
      showAddDogPopup(context);
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse("${apiBaseUrl}/gishor/predict-with-voice"));
    request.files.add(
        await http.MultipartFile.fromPath('file', _selectedAudioFile!.path));

    var response = await request.send();

    String responseBody = await response.stream.bytesToString();
    printLog(responseBody);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(responseBody);
      String breed = responseData["predicted_breed"];

      await SharedPreferencesHelper.setString("local_storage_dog_breed", breed);
      showAddDogPopup(context);

      print('Upload successful');
    } else {
      print('Upload failed');
    }
  }

  // Future<void> _apiUploadAudioFile() async {
  //   if (_selectedAudioFile == null) return;

  //   try {
  //     // Read file as bytes
  //     List<int> fileBytes = await File(_selectedAudioFile!.path).readAsBytes();

  //     // Convert to Base64 string
  //     String base64Audio = base64Encode(fileBytes);

  //     print(base64Audio);

  //     printLog("Base64 Audio: ${base64Audio.substring(0, 50)}...");
  //     printLog("API URL: ${apiBaseUrl}/gishor/predict-with-voice-base64");

  //     // Send API request
  //     var response = await http.post(
  //       Uri.parse("${apiBaseUrl}/gishor/predict-with-voice-base64"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"audio_base64": base64Audio}),
  //     );

  //     printLog("Status Code: ${response.statusCode}");
  //     printLog("Response Body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       print('Upload successful');
  //       showAddDogPopup(context);
  //     } else {
  //       print('Upload failed');
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  //! Api call For upload by Image
  Future<void> _apiUploadImageFile() async {
    if (_image == null) {
      print("No image selected!");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    if (useDemoData) {
      await Future.delayed(Duration(milliseconds: demoDelayMs));
      final Map<String, dynamic> responseData = demoPredictWithImageResponse;
      String breed = responseData["prediction"]?["breed"] ?? "Golden Retriever";
      await SharedPreferencesHelper.setString("local_storage_dog_breed", breed);
      showAddDogPopup(context);
      setState(() => _isLoading = false);
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${apiBaseUrl}/gishor/predict-with-image"),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          filename: path.basename(_image!.path),
        ),
      );

      printLog("API BASE URLLLLLL ${apiBaseUrl}");

      var response = await request.send();

      String responseBody = await response.stream.bytesToString();
      print("Response Code: ${response.statusCode}");
      print("Response Body: $responseBody");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        String breed = responseData["prediction"]["breed"];

        printLog(breed);

        await SharedPreferencesHelper.setString(
            "local_storage_dog_breed", breed);
        showAddDogPopup(context);
        print(responseBody);
      } else {
        print(" Failed to upload image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print(" Error uploading image: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //?Search By Voice or Immage Option
  void _showPickerDialogOption() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.audio_file),
              title: Text("By Voice"),
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  _pickAudioFile();
                });

                // _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_rounded),
              title: const Text("By Image"),
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  _showPickerDialog();
                });

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //? Image Picker

  void _showPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: const Text("Camera"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

//! CRUD OPERATION>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//! Delete Dog
  void showDeleteConfirmationDialog(BuildContext context, String dogId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Dog"),
          content: Text("Are you sure you want to delete this dog?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await deleteDog(dogId);
                Navigator.of(context).pop(); // Close the dialog
                showTopSnackBar(
                    context, "Dog deleted successfully!", Colors.red);
                moveToScreen(context, ScreenRoutes.toBottomNavbar);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteDog(String dogId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await firestore
        .collection("users")
        .doc(user.uid)
        .collection("dogs")
        .doc(dogId)
        .delete();
  }

  ///! Add Dogggggggggggggggggggggggggg
  void showAddDogPopup(BuildContext context) async {
    String _dogBreed =
        await SharedPreferencesHelper.getString("local_storage_dog_breed") ??
            "";
    breedController.text = _dogBreed;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Dog"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    autovalidate: true,
                    readOnly: _dogBreed.isEmpty ? false : true,
                    textInputType: TextInputType.name,
                    controller: breedController,
                    labelText: "Breed",
                    obscure: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Breed is Required";
                      }
                      return null;
                    },
                  ),
                  const ColumnSpacer(0.02),
                  CustomTextFormField(
                    autovalidate: true,
                    textInputType: TextInputType.name,
                    controller: nameController,
                    labelText: "Name",
                    obscure: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is Required";
                      }
                      return null;
                    },
                  ),
                  const ColumnSpacer(0.02),

                  CustomTextFormField(
                    autovalidate: true,
                    textInputType: TextInputType.number,
                    controller: ageController,
                    labelText: "Age",
                    obscure: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Age is Required";
                      }
                      final int? age = int.tryParse(value);
                      if (age == null || age < 0 || age > 20) {
                        return "Enter a valid age between 0 and 20";
                      }
                      return null;
                    },
                  ),
                  const ColumnSpacer(0.02),

                  CustomDropdown(
                    autovalidate: true,
                    labelText: "Gender",
                    hintText: "Choose one",
                    items: const [
                      "Male",
                      "Female",
                    ],
                    value: genderSelectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        genderSelectedValue = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Gender is Required";
                      }
                      return null;
                    },
                  ),
                  const ColumnSpacer(0.02),

                  CustomTextFormField(
                    autovalidate: true,
                    textInputType: TextInputType.number,
                    controller: weightController,
                    labelText: "Weight",
                    obscure: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Weight is Required";
                      }
                      final int? weight = int.tryParse(value);
                      if (weight == null || weight < 5 || weight > 100) {
                        return "Enter a valid weight between 5 and 100";
                      }
                      return null;
                    },
                  )
                  // TextField(
                  //   controller: weightController,
                  //   decoration: InputDecoration(labelText: "Weight"),
                  //   keyboardType: TextInputType.number,
                  // ),
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
                if (_formKey.currentState!.validate()) {
                  saveDogData(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDogData(BuildContext context) async {
    // if (breedController.text.isEmpty || nameController.text.isEmpty) {
    //   showTopSnackBar(
    //       context, "Breed and Name are required!", Colors.redAccent);

    //   return;
    // }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String newDogId = firestore
        .collection("users")
        .doc(user!.uid)
        .collection("dogs")
        .doc()
        .id;

    await firestore
        .collection("users")
        .doc(user.uid)
        .collection("dogs")
        .doc(newDogId)
        .set({
      "breed": breedController.text,
      "image":
          "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "name": nameController.text,
      "age":
          ageController.text.isNotEmpty ? int.parse(ageController.text) : null,
      "gender": genderSelectedValue,
      "weight": weightController.text.isNotEmpty
          ? double.parse(weightController.text)
          : null,
    });

    await SharedPreferencesHelper.setString(
        "local_storage_dog_name", nameController.text.toString());
    await SharedPreferencesHelper.setString(
        "local_storage_dog_age", ageController.text.toString());
    await SharedPreferencesHelper.setString(
        "local_storage_dog_gender", genderSelectedValue.toString());
    await SharedPreferencesHelper.setString(
        "local_storage_dog_weight", weightController.text.toString());
    Navigator.pop(context);
    showTopSnackBar(context, "Dog added successfully!", Colors.green);
    moveToScreen(context, ScreenRoutes.toBottomNavbar);
  }
}
