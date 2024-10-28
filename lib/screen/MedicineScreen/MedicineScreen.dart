// // ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables, depend_on_referenced_packages

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path; // To get the basename of the file
// import 'package:rpskindisease/screen/BottomNavigation/BottomNavigationScreen.dart';
// import 'package:rpskindisease/screen/HomeScreen/HomeScreen.dart';
// import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MedicineScreen extends StatefulWidget {
//   const MedicineScreen({super.key});

//   @override
//   State<MedicineScreen> createState() => _MedicineScreenState();
// }

// class _MedicineScreenState extends State<MedicineScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   var skindisease;
//   var accuracy;
//   var apiBaseUrl;
//   var apipredictUrl;

//   bool _isLoading = false;

//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? pickedFile = await _picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<Map<String, dynamic>?> getNestedDocumentData() async {
//     try {
//       DocumentSnapshot snapshotvalidate = await FirebaseFirestore.instance
//           .collection("config")
//           .doc("prediction")
//           .get();

//       if (snapshotvalidate.exists) {
//         print("dataa>>");
//         print(snapshotvalidate.data());
//         var validate = snapshotvalidate.data() as Map<String, dynamic>;
//         print(validate["url"]);

//         setState(() {
//           apiBaseUrl = validate["url"];
//         });

//         return snapshotvalidate.data() as Map<String, dynamic>;
//       } else {
//         print('No data found');
//         return null;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return null;
//     }
//   }

//   //! Upload Image 1111

//   var validateImage;
//   Future<void> _uploadImage() async {
//     if (_image == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     var request =
//         http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/validate"));
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'files', // Key of the request
//         _image!.path,
//         filename: path.basename(_image!.path),
//       ),
//     );
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final decodedResponse = jsonDecode(responseBody);

//       print(decodedResponse);
//       print(response.contentLength);
//       print(decodedResponse['most_common_prediction']);
//       setState(() {
//         validateImage = decodedResponse['most_common_prediction'];
//       });
//       print("Image uploaded successfully!");
//       setState(() {
//         _isLoading = false;
//       });

//       if (validateImage == "Skin image") {
//         _imageValidatrion(context, "Image Validated $validateImage");
//       } else {
//         _imageValidatrion(
//             context, "Invalid Image Type... Please input Another ");
//       }
//     } else {
//       print("Failed to upload image. Status code: ${response.statusCode}");
//     }
//   }

//   //! Upload Image 2

//   Future<void> _uploadImage2() async {
//     print('Image Noty Null');
//     print(_image);
//     print(apipredictUrl);
//     if (_image == null) return;

//     var request =
//         http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/predict"));
//     print("request>>>>>>>>>");
//     print(request);
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'files', // Key of the request
//         _image!.path,
//         filename: path.basename(_image!.path),
//       ),
//     );

//     print("januauauaua");
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final decodedResponse = jsonDecode(responseBody);

//       setState(() {
//         skindisease = decodedResponse['prediction'];
//         accuracy = decodedResponse['confidence'];
//       });
//       print("Image uploaded successfully!");
//       // print(skindisease.length);
//       _showPopup(context);
//     } else {
//       print("Failed to upload image. Status code: ${response.statusCode}");
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

//   void _imageValidatrion(BuildContext context, String imagevalue) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('$imagevalue'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (validateImage == "Skin image") {
//                   Navigator.pop(context);
//                   _uploadImage2();
//                 } else {
//                   Navigator.pop(context);
//                 }
//                 // getNestedDocumentData2();
//               },
//               child: validateImage == "Skin image"
//                   ? Text('Continue')
//                   : Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Skin Disease Stage'),
//           content: SizedBox(
//             height: 100,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Your Skin Disease Is :',
//                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   '${skindisease}',
//                   style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text('Accuracy level : ${accuracy}',
//                     style:
//                         TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.to(BottomNavigationScreen());
//               },
//               child: Text('Continue'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     getNestedDocumentData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Skin Disease Stages Prediction"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         child: Column(
//           children: <Widget>[
//             GestureDetector(
//               onTap: _showImagePickerOptions,
//               child: Center(
//                 child: Container(
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
//                               SizedBox(height: 10),
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
//             SizedBox(height: 100),
//             _image != null
//                 ? _isLoading
//                     ? CupertinoActivityIndicator(
//                         radius: 15,
//                       )
//                     : CustomElevatedButton(
//                         onPressed: _uploadImage, // Upload the image
//                         // onPressed: () => Get.to(MedicineScreen()),
//                         label: "Continue",
//                       )
//                 : SizedBox()
//           ],
//         ),
//       ),
//     );
//   }
// }

//!11111111111111111111111

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
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  var skindisease;
  var accuracy;
  var apiBaseUrl;
  var apipredictUrl;

  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  // Function to remove an image from the list
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<Map<String, dynamic>?> getNestedDocumentData() async {
    try {
      DocumentSnapshot snapshotvalidate = await FirebaseFirestore.instance
          .collection("config")
          .doc("prediction")
          .get();

      if (snapshotvalidate.exists) {
        print("dataa>>");
        print(snapshotvalidate.data());
        var validate = snapshotvalidate.data() as Map<String, dynamic>;
        print(validate["url"]);

        setState(() {
          apiBaseUrl = validate["url"];
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

  //! Upload Image 1111

  var validateImage;
  Future<void> _uploadImage() async {
    if (_images.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    var request =
        http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/validate"));

    // request.files.add(
    //   await http.MultipartFile.fromPath(
    //     'files', // Key of the request
    //     _image!.path,
    //     filename: path.basename(_image!.path),
    //   ),
    // );

    for (var image in _images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files', // Key of the request
          image.path,
          filename: path.basename(image.path),
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      print(decodedResponse);
      print(response.contentLength);
      print(decodedResponse['most_common_prediction']);
      setState(() {
        validateImage = decodedResponse['most_common_prediction'];
      });
      print("Image uploaded successfully!");
      setState(() {
        _isLoading = false;
      });

      if (validateImage == "Skin image") {
        _imageValidatrion(context, "Image Validated $validateImage");
      } else {
        _imageValidatrion(
            context, "Invalid Image Type... Please input Another ");
      }
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
    }
  }

  //! Upload Image 2

  Future<void> _uploadImage2() async {
    print('Image Noty Null');

    print(apipredictUrl);
    if (_images.isEmpty) return;

    var request =
        http.MultipartRequest('POST', Uri.parse("$apiBaseUrl/predict"));
    print("request>>>>>>>>>");
    print(request);

    for (var image in _images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files', // Key of the request
          image.path,
          filename: path.basename(image.path),
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      print("Responseeeeee>>>>>>>>>>>>>>>");
      print(decodedResponse);

      setState(() {
        skindisease = decodedResponse['most_common_prediction'];
        accuracy = decodedResponse['average_confidence'];
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

  void _imageValidatrion(BuildContext context, String imagevalue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$imagevalue'),
          actions: [
            TextButton(
              onPressed: () {
                if (validateImage == "Skin image") {
                  Navigator.pop(context);
                  _uploadImage2();
                } else {
                  Navigator.pop(context);
                }
                // getNestedDocumentData2();
              },
              child: validateImage == "Skin image"
                  ? Text('Continue')
                  : Text('Close'),
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
        title: Text("Skin Disease Stage Prediction"),
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
                  ),
                  child: _images.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Tap to Select Images"),
                              SizedBox(height: 10),
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(_images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
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
                            );
                          },
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _images.isNotEmpty
                ? _isLoading
                    ? CupertinoActivityIndicator(radius: 15)
                    : CustomElevatedButton(
                        onPressed: _uploadImage,
                        label: 'Continue',
                      )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
