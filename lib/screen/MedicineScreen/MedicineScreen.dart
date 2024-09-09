// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path; // To get the basename of the file
import 'package:rpskindisease/screen/BottomNavigation/BottomNavigationScreen.dart';
import 'package:rpskindisease/screen/HomeScreen/HomeScreen.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  var skindisease;
  var accuracy;
  var apivalidateUrl;
  var apipredictUrl;

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
      DocumentSnapshot snapshotvalidate = await FirebaseFirestore.instance
          .collection("config")
          .doc("stagevalidate")
          .get();

      if (snapshotvalidate.exists) {
        print("dataa>>");
        print(snapshotvalidate.data());
        var validate = snapshotvalidate.data() as Map<String, dynamic>;
        print(validate["url"]);

        setState(() {
          apivalidateUrl = validate["url"];
        });

        return snapshotvalidate.data() as Map<String, dynamic>;
      } else {
        print('No data found');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getNestedDocumentData2() async {
    try {
      DocumentSnapshot snapshotpredict = await FirebaseFirestore.instance
          .collection("config")
          .doc("stagepredict")
          .get();

      if (snapshotpredict.exists) {
        print("dataa>>");
        print(snapshotpredict.data());
        var validate = snapshotpredict.data() as Map<String, dynamic>;
        print(validate["url"]);

        setState(() {
          apipredictUrl = validate["url"];
        });

        print("upload Image 2");
        print(_image);
        _uploadImage2();
        return snapshotpredict.data() as Map<String, dynamic>;
      } else {
        print('No data found');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  //! Upload Image 1111

  var validateImage;
  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST', Uri.parse(apivalidateUrl));
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // Key of the request
        _image!.path,
        filename: path.basename(_image!.path),
      ),
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);
      print(response.contentLength);
      print(decodedResponse['prediction']);
      setState(() {
        validateImage = decodedResponse['prediction'];
      });
      print("Image uploaded successfully!");
      setState(() {
        _isLoading = false;
      });
      _imageValidatrion(context);
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
    }
  }

  //! Upload Image 2

  Future<void> _uploadImage2() async {
    print('Image Noty Null');
    print(_image);
    print(apipredictUrl);
    if (_image == null) return;

    // Replace with your API endpoint
    // final String apiUrl = 'https://81a3-34-125-218-192.ngrok-free.app/predict';
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apipredictUrl));
    print("request>>>>>>>>>");
    print(request);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // Key of the request
        _image!.path,
        filename: path.basename(_image!.path),
      ),
    );

    print("januauauaua");
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      setState(() {
        skindisease = decodedResponse['prediction'];
        accuracy = decodedResponse['confidence'];
      });
      print("Image uploaded successfully!");
      // print(skindisease.length);
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

  void _imageValidatrion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Validated'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                getNestedDocumentData2();
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Skin Disease Stage'),
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Skin Disease Is :',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${skindisease}',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
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
                Get.to(BottomNavigationScreen());
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
        title: Text("Skin Disease Stages Prediction"),
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
                        // onPressed: () => Get.to(MedicineScreen()),
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




