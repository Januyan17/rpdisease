// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path; // To get the basename of the file
import 'package:rpskindisease/screen/HomeScreen/DiseaseIdentification/disease-identification.dart';
import 'package:rpskindisease/screen/HomeScreen/SkinTypePrediction/skintype-predict.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkinTonePrediction extends StatefulWidget {
  const SkinTonePrediction({super.key});

  @override
  State<SkinTonePrediction> createState() => _SkinTonePredictionState();
}

class _SkinTonePredictionState extends State<SkinTonePrediction> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  var skintone;
  var accuracy;
  var apiUrl;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, dynamic>?> getNestedDocumentData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("config")
          .doc("ngrok_url")
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

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });
    // Replace with your API endpoint
    // final String apiUrl = 'https://81a3-34-125-218-192.ngrok-free.app/predict';
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Key of the request
        _image!.path,
        filename: path.basename(_image!.path),
      ),
    );

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);
      print(response.contentLength);
      print(decodedResponse['class']);
      print(decodedResponse['confidence_score']);
      setState(() {
        skintone = decodedResponse['class'].substring(2);
        accuracy = decodedResponse['confidence_score'];
      });
      print("Image uploaded successfully!");
      print(skintone.length);
      setState(() {
        _isLoading = false;
      });
      _showPopup(context);
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
    }
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

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Skin Tone'),
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Your Skin Tone Is :',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${skintone}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Accuracy level : ${accuracy}',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(SkinTypePrediction());
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skin Tone Prediction"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
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
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Tap to Select The Image"),
                              SizedBox(height: 10),
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 100),
            _image != null
                ? _isLoading
                    ? CupertinoActivityIndicator(
                        radius: 15,
                      )
                    : CustomElevatedButton(
                        onPressed: _uploadImage, // Upload the image
                        // onPressed: () => Get.to(SkinTypePrediction()),
                        label: "Continue",
                      )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}


// // ignore_for_file: prefer_const_constructors, unused_field

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rpskindisease/screen/HomeScreen/SkinTypePrediction/skintype-predict.dart';
// import 'package:rpskindisease/widgets/AuthReusable/Button.dart';

// class SkinTonePrediction extends StatefulWidget {
//   SkinTonePrediction({super.key});

//   @override
//   State<SkinTonePrediction> createState() => _SkinTonePredictionState();
// }

// class _SkinTonePredictionState extends State<SkinTonePrediction> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? pickedFile = await _picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   void _showImagePickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text('Choose an option',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 20),
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Select from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Skin Tone'),
//           content: Text('Your Skin Tone Is  Medium Complexion'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.to(SkinTypePrediction());
//               },
//               child: Text('Continue'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Skin Tone Prediction"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         child: Column(
//           children: <Widget>[
//             GestureDetector(
//               onTap: _showImagePickerOptions,
//               child: Center(
//                 child: Container(
//                   // margin: EdgeInsets.all(40),
//                   width: 350,
//                   height: 350,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10),
//                     image: _image != null
//                         ? DecorationImage(
//                             image: FileImage(_image!),
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                   ),
//                   child: _image == null
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Tap to Select The Image"),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Icon(
//                                 Icons.image,
//                                 size: 50,
//                                 color: Colors.grey[600],
//                               ),
//                             ],
//                           ),
//                         )
//                       : null,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 100,
//             ),
//             _image != null
//                 ? CustomElevatedButton(
//                     onPressed: () {
//                       _showPopup(context);
//                     },
//                     label: "Continue")
//                 : SizedBox()
//           ],
//         ),
//       ),
//     );
//   }
// }




