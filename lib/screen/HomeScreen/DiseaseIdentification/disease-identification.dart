// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path; // To get the basename of the file
import 'package:rpskindisease/constants.dart';
import 'package:rpskindisease/screen/BottomNavigation/BottomNavigationScreen.dart';
import 'package:rpskindisease/screen/WebScrapping/WebScrapping.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseIdentification extends StatefulWidget {
  const DiseaseIdentification({super.key});

  @override
  State<DiseaseIdentification> createState() => _DiseaseIdentificationState();
}

class _DiseaseIdentificationState extends State<DiseaseIdentification> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  var skindisease;
  var accuracy;
  var apiUrl;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    // final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    // if (pickedFiles != null) {
    //   setState(() {
    //     _images = pickedFiles.map((file) => File(file.path)).toList();
    //   });
    // }
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<Map<String, dynamic>?> getNestedDocumentData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("config")
          .doc("ngrok_url")
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          apiUrl = data["url"];
        });
        return data;
      } else {
        print('No data found');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  final Map<String, String> diseases = {
    'Acne':
        'https://www.mayoclinic.org/diseases-conditions/acne/symptoms-causes/syc-20368047',
    'Cellulitis':
        'https://www.mayoclinic.org/diseases-conditions/cellulitis/symptoms-causes/syc-20370762',
    'Dermatitis':
        'https://www.mayoclinic.org/diseases-conditions/dermatitis-eczema/symptoms-causes/syc-20352380',
    'Eczema':
        'https://www.mayoclinic.org/diseases-conditions/atopic-dermatitis-eczema/symptoms-causes/syc-20353273',
    'Ivy':
        'https://www.mayoclinic.org/diseases-conditions/poison-ivy/symptoms-causes/syc-20376485',
    'Psoriasis':
        'https://www.mayoclinic.org/diseases-conditions/psoriasis/symptoms-causes/syc-20355840',
    'Scabies':
        'https://www.mayoclinic.org/diseases-conditions/scabies/symptoms-causes/syc-20377378',
    'Warts':
        'https://www.mayoclinic.org/diseases-conditions/common-warts/symptoms-causes/syc-20371125'
  };

  Future<void> _uploadImages() async {
    if (_images.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
        'POST', Uri.parse("$apiUrl/predict/skin_disease"));

    // Add each selected image to the request
    for (var image in _images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Key of the request
          image.path,
          filename: path.basename(image.path),
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      setState(() {
        skindisease = decodedResponse['class'].substring(2);
        accuracy = decodedResponse['confidence_score'];
        _isLoading = false;
      });

      print(getDiseaseUrl(skindisease.toString()));

      _showPopup(context);
    } else {
      Get.snackbar("Error", "Invalid Image",
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Failed to upload images. Status code: ${response.statusCode}");
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getDiseaseUrl(String disease) {
    switch (disease) {
      case 'Acne':
        return diseases['Acne']!;
      case 'Cellulitis':
        return diseases['Cellulitis']!;
      case 'Dermatitis':
        return diseases['Dermatitis']!;
      case 'Eczema':
        return diseases['Eczema']!;
      case 'Ivy':
        return diseases['Ivy']!;
      case 'Psoriasis':
        return diseases['Psoriasis']!;
      case 'Scabies':
        return diseases['Scabies']!;
      case 'Warts':
        return diseases['Warts']!;
      default:
        return 'https://www.mayoclinic.org'; // Default URL or handle error
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
              Text(
                'Choose an option',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
          title: Text('Skin Disease'),
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Your Skin Disease Is :',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '$skindisease',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                // SizedBox(height: 5),
                // Text('Accuracy level : $accuracy',
                //     style:
                //         TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // _showPopup2(context);
                setState(() {
                  _isVisible = true;
                });
                // Get.to(BottomNavigationScreen());
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  bool _isVisible = false;

  void _showPopup2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Want to Know More About $skindisease?'),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Get.to(BottomNavigationScreen());
                    setState(() {
                      _isVisible = false;
                    });
                  },
                  child: Text('NO'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = false;
                    });
                    Get.to(WebPage(
                      title: skindisease.toString(),
                      url: getDiseaseUrl(
                        skindisease.toString(),
                      ),
                    ));
                  },
                  child: Text('YES'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScrollEnd);
    getNestedDocumentData();
    super.initState();
  }

  void _onScrollEnd() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        // Show the dialog when scrolled to the bottom
        _showPopup2(context);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skin Disease Prediction"),
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
                              Icon(Icons.image,
                                  size: 50, color: Colors.grey[600]),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: _images.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
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
                                    onTap: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close,
                                          size: 16, color: Colors.white),
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
            SizedBox(height: 40),
            _images.isNotEmpty
                ? _isLoading
                    ? CupertinoActivityIndicator(radius: 15)
                    : CustomElevatedButton(
                        onPressed: _uploadImages, // Upload all selected images
                        label: "Continue",
                      )
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            _isVisible
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Text(
                              diseaseHeading,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),

                            if (skindisease == "Warts")
                              Text(diseaseOverView[0]['warts']!),
                            if (skindisease == "Acne")
                              Text(diseaseOverView[1]['acne']!),
                            if (skindisease == "Cellulitis")
                              Text(diseaseOverView[2]['cellulitis']!),
                            if (skindisease == "Dermatitis")
                              Text(diseaseOverView[3]['dermatitis']!),
                            if (skindisease == "Eczema")
                              Text(diseaseOverView[4]['eczema']!),
                            // if (skindisease == "Warts")

                            //!!!!!!!!!!!!!!!!!!!!!!

                            Text(
                              diseaseHeading2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (skindisease == "Warts") ...[
                                  // First set of symptoms
                                  Text(
                                    "*${diseaseSymptom[0]["symptom1"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[0]["symptom2"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[0]["symptom3"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ] else if (skindisease == "Acne") ...[
                                  // Second set of symptoms
                                  Text(
                                    "*${diseaseSymptom[1]["symptom1"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[1]["symptom2"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[1]["symptom3"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ] else if (skindisease == "Cellulitis") ...[
                                  // Third set of symptoms
                                  Text(
                                    "*${diseaseSymptom[2]["symptom1"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[2]["symptom2"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[2]["symptom3"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ] else if (skindisease == "Dermatitis") ...[
                                  // Fourth set of symptoms
                                  Text(
                                    "*${diseaseSymptom[3]["symptom1"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[3]["symptom2"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[3]["symptom3"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ] else if (skindisease == "Eczema") ...[
                                  // Fifth set of symptoms
                                  Text(
                                    "*${diseaseSymptom[4]["symptom1"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[4]["symptom2"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "*${diseaseSymptom[4]["symptom3"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ],
                            ),

                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       "*${diseaseSymptom[0]["symptom1"]}",
                            //       style: TextStyle(
                            //           fontSize: 15,
                            //           fontWeight: FontWeight.w700),
                            //     ),
                            //     Text("*${diseaseSymptom[0]["symptom2"]}",
                            //         style: TextStyle(
                            //             fontSize: 15,
                            //             fontWeight: FontWeight.w700)),
                            //     Text("* ${diseaseSymptom[0]["symptom3"]}",
                            //         style: TextStyle(
                            //             fontSize: 15,
                            //             fontWeight: FontWeight.w700)),
                            //   ],
                            // ),
                          ],
                        )))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}



// class _DiseaseIdentificationState extends State<DiseaseIdentification> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   var skindisease;
//   var accuracy;
//   var apiUrl;
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
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection("config")
//           .doc("ngrok_url")
//           .get();

//       if (snapshot.exists) {
//         print("dataa>>");
//         print(snapshot.data());
//         var data = snapshot.data() as Map<String, dynamic>;
//         print(data["url"]);
//         setState(() {
//           apiUrl = data["url"];
//         });
//         return snapshot.data() as Map<String, dynamic>;
//       } else {
//         print('No data found');
//         return null;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return null;
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (_image == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     var request = http.MultipartRequest(
//         'POST', Uri.parse("$apiUrl/predict/skin_disease"));
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'image', // Key of the request
//         _image!.path,
//         filename: path.basename(_image!.path),
//       ),
//     );

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final decodedResponse = jsonDecode(responseBody);
//       print(response.contentLength);
//       print(decodedResponse['class']);
//       print(decodedResponse['confidence_score']);
//       setState(() {
//         skindisease = decodedResponse['class'].substring(2);
//         accuracy = decodedResponse['confidence_score'];
//       });
//       print("Image uploaded successfully!");
//       print(skindisease.length);
//       setState(() {
//         _isLoading = false;
//       });
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

//   void _showPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Skin Disease'),
//           content: SizedBox(
//             height: 100,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Your Skin Disease Is :',
//                       style:
//                           TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       '${skindisease}',
//                       style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red),
//                     ),
//                   ],
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
//         title: Text("Skin Disease Prediction"),
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
//                         // onPressed: () => Get.to(DiseaseIdentification()),
//                         label: "Continue",
//                       )
//                 : SizedBox()
//           ],
//         ),
//       ),
//     );
//   }
// }
