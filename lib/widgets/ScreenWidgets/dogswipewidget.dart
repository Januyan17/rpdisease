import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/utils/log_util.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:rpskindisease/utils/spacers/screen_size_calculator.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/containers/custom_dog_widget.dart';
import 'package:rpskindisease/widgets/loader/custom_loader.dart';
import 'package:rpskindisease/widgets/snakbar/snakbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

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
                "id": doc.id
              })
          .toList();

      setState(() {
        dogs = tempDogs;
      });
    } catch (e) {
      print("Error fetching dogs: $e");
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
                    return SizedBox(
                      width: 10,
                    );
                  },
                ),
    );
  }

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['m4a', 'mp3'],
    );
    if (result != null) {
      setState(() {
        _selectedAudioFile = File(result.files.single.path!);
      });
      // _uploadAudioFile();
    }
  }

  // Future<void> _uploadAudioFile() async {
  //   if (_selectedAudioFile == null) return;

  //   var request =
  //       http.MultipartRequest('POST', Uri.parse('https://yourapi.com/upload'));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'audioFile', _selectedAudioFile!.path));

  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     print('Upload successful');
  //   } else {
  //     print('Upload failed');
  //   }
  // }

  //!Search By Voice or Immage Option
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
              leading: Icon(Icons.image_rounded),
              title: Text("By Image"),
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
        title: Text("Pick Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Gallery"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      printLog("Breed : Image is :><><><> ${_image!.path}");
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      showAddDogPopup(context);
    });
    Navigator.pop(context);
  }

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
  void showAddDogPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Dog"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                    textInputType: TextInputType.name,
                    controller: breedController,
                    labelText: "Breed",
                    obscure: false),
                CustomTextFormField(
                    textInputType: TextInputType.name,
                    controller: nameController,
                    labelText: "Name",
                    obscure: false),
                CustomTextFormField(
                    textInputType: TextInputType.number,
                    controller: ageController,
                    labelText: "Age",
                    obscure: false),
                CustomTextFormField(
                    textInputType: TextInputType.name,
                    controller: genderController,
                    labelText: "Gender",
                    obscure: false),
                CustomTextFormField(
                    textInputType: TextInputType.number,
                    controller: weightController,
                    labelText: "Weight",
                    obscure: false),
                // TextField(
                //   controller: weightController,
                //   decoration: InputDecoration(labelText: "Weight"),
                //   keyboardType: TextInputType.number,
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                saveDogData(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDogData(BuildContext context) async {
    if (breedController.text.isEmpty || nameController.text.isEmpty) {
      showTopSnackBar(
          context, "Breed and Name are required!", Colors.redAccent);

      return;
    }

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
      "gender": genderController.text,
      "weight": weightController.text.isNotEmpty
          ? double.parse(weightController.text)
          : null,
    });

    Navigator.pop(context);
    showTopSnackBar(context, "Dog added successfully!", Colors.green);
    moveToScreen(context, ScreenRoutes.toBottomNavbar);
  }
}
