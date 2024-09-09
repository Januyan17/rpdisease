// // ignore_for_file: sort_child_properties_last, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';
// import 'package:rpskindisease/screen/HomeScreen/CarousalSlider.dart';
// import 'package:rpskindisease/screen/HomeScreen/HomeScreenSearch.dart';

// class HomeScreenPage extends StatelessWidget with ResponsiveLayoutMixin {
//   HomeScreenPage({super.key});

//   final List<String> imageList = [
//     'https://img.freepik.com/free-photo/portrait-woman-with-hydrated-skin_23-2149418642.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1724112000&semt=ais_hybrid',
//     'https://img.freepik.com/free-photo/side-view-senior-woman-skin-texture_23-2149457631.jpg',
//     'https://img.freepik.com/free-photo/side-view-man-with-skin-problems_23-2149441220.jpg',
//     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKJ2ctHJwdvKcXLU6fKakTSuRY9Pj3SqWpMQQXJthW_CPsDLAcVyBQIiR-pbCqgovzR1s&usqp=CAU',
//     'https://media.istockphoto.com/id/1460105832/photo/woman-legs-and-beauty-in-studio-for-skin-grooming-and-hygiene-treatment-against-grey-a.jpg?s=612x612&w=0&k=20&c=h6iXv1vfWPWGcL7R_U6HLjB0aFQ_cYr7xWrDbCo3MZU=',
//     'https://media.istockphoto.com/id/1436379195/photo/woman-moisturizes-dry-skin-on-heels-with-cream-skin-care.jpg?s=612x612&w=0&k=20&c=I8xyLzN54Ep-5EptDbMQqYwdSG0-AsSDcRrB4mG0040=',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Screen"),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //! Search Bar
//                 Container(
//                   color: Colors.red,
//                   height: getScreenHeight(context) * 0.08,
//                   width: getScreenWidth(context) * 0.8,
//                   child: CustomSearchBar(),
//                 ),
//                 SizedBox(
//                   height: getScreenHeight(context) * 0.05,
//                 ),
//                 Text(
//                   "Transforming Skin Disease Diagnosis with Machine Learning",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 Text(
//                   "A New Era in Dermatology",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(
//                   height: getScreenHeight(context) * 0.03,
//                 ),
//                 SizedBox(
//                   height: getScreenHeight(context) * 0.18,
//                   width: getScreenWidth(context),
//                   child: CustomCarouselSlider(),
//                 ),
//                 SizedBox(
//                   height: getScreenHeight(context) * 0.03,
//                 ),
//                 //! Know Your Disease
//                 Text(
//                   "Know Your Disease",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: getScreenHeight(context) * 0.03,
//                 ),
//                 //! All Type of Disease
//                 SizedBox(
//                   height: getScreenHeight(context) * 0.5,
//                   child: GridView.count(
//                     crossAxisCount: 3, // 3 columns
//                     childAspectRatio: (getScreenWidth(context) * 0.25) /
//                         (getScreenHeight(context) *
//                             0.19), // Adjust aspect ratio
//                     children: List.generate(imageList.length, (index) {
//                       String tooltipMessage;
//                       switch (index) {
//                         case 0:
//                           tooltipMessage =
//                               'Back'; // Message for the first image
//                           break;
//                         case 1:
//                           tooltipMessage =
//                               'Chest'; // Message for the second image
//                           break;
//                         case 2:
//                           tooltipMessage =
//                               'Face'; // Message for the third image
//                           break;
//                         case 3:
//                           tooltipMessage =
//                               'Hand'; // Message for the fourth image
//                           break;
//                         case 4:
//                           tooltipMessage = 'Leg'; // Message for the fifth image
//                           break;
//                         case 5:
//                           tooltipMessage =
//                               'Feet'; // Message for the sixth image
//                           break;
//                         default:
//                           tooltipMessage =
//                               'Image ${index + 1}'; // Default message for other images
//                       }

//                       return Column(
//                         children: [
//                           Expanded(
//                             child: Tooltip(
//                               message: tooltipMessage,
//                               textStyle: TextStyle(
//                                   color: Colors.white), // Tooltip text color
//                               decoration: BoxDecoration(
//                                 color: Colors.black, // Tooltip background color
//                                 borderRadius: BorderRadius.circular(
//                                     8.0), // Rounded corners
//                               ),
//                               child: Container(
//                                 margin: EdgeInsets.all(8.0),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: NetworkImage(imageList[index]),
//                                     fit: BoxFit.cover,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // SizedBox(height: 8.0), // Space between image and button
//                           SizedBox(
//                             width: 100, // Make button take full width
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 _showPopup(context, tooltipMessage);
//                               },
//                               child: Text('View'),
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//                     shrinkWrap: true,
//                     physics:
//                         NeverScrollableScrollPhysics(), // Disable scrolling
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showPopup(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('${message} Skin Disease Details'),
//           content: Text('Details about: $message'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';
import 'package:rpskindisease/screen/HomeScreen/CarousalSlider.dart';
import 'package:rpskindisease/screen/HomeScreen/HomeScreenSearch.dart';
import 'package:rpskindisease/screen/HomeScreen/SkinTonePrediction/skintone-prediction.dart';

class HomeScreenPage extends StatelessWidget with ResponsiveLayoutMixin {
  HomeScreenPage({super.key});

  final List<String> imageList = [
    'https://img.freepik.com/free-photo/portrait-woman-with-hydrated-skin_23-2149418642.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1724112000&semt=ais_hybrid',
    'https://img.freepik.com/free-photo/side-view-senior-woman-skin-texture_23-2149457631.jpg',
    'https://img.freepik.com/free-photo/side-view-man-with-skin-problems_23-2149441220.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKJ2ctHJwdvKcXLU6fKakTSuRY9Pj3SqWpMQQXJthW_CPsDLAcVyBQIiR-pbCqgovzR1s&usqp=CAU',
    'https://media.istockphoto.com/id/1460105832/photo/woman-legs-and-beauty-in-studio-for-skin-grooming-and-hygiene-treatment-against-grey-a.jpg?s=612x612&w=0&k=20&c=h6iXv1vfWPWGcL7R_U6HLjB0aFQ_cYr7xWrDbCo3MZU=',
    'https://media.istockphoto.com/id/1436379195/photo/woman-moisturizes-dry-skin-on-heels-with-cream-skin-care.jpg?s=612x612&w=0&k=20&c=I8xyLzN54Ep-5EptDbMQqYwdSG0-AsSDcRrB4mG0040=',
  ];

  // Define different content for each image
  final Map<int, String> contentMap = {
    0: 'Back: Information about back skin diseases.',
    1: 'Chest: Information about chest skin diseases.',
    2: 'Face: Information about face skin diseases.',
    3: 'Hand: Information about hand skin diseases.',
    4: 'Leg: Information about leg skin diseases.',
    5: 'Feet: Information about feet skin diseases.',
  };

  final List skinDiseases = [
    "Back",
    "Chest",
    "Face",
    "Hand",
    "Leg",
    "Feet",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //! Search Bar
                Container(
                  color: Colors.red,
                  height: getScreenHeight(context) * 0.08,
                  width: getScreenWidth(context) * 0.8,
                  child: CustomSearchBar(),
                ),
                SizedBox(
                  height: getScreenHeight(context) * 0.05,
                ),
                Text(
                  "Transforming Skin Disease Diagnosis with Machine Learning",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "A New Era in Dermatology",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: getScreenHeight(context) * 0.03,
                ),
                SizedBox(
                  height: getScreenHeight(context) * 0.18,
                  width: getScreenWidth(context),
                  child: CustomCarouselSlider(),
                ),
                SizedBox(
                  height: getScreenHeight(context) * 0.03,
                ),
                //! Know Your Disease
                Text(
                  "Know Your Disease",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: getScreenHeight(context) * 0.03,
                ),
                //! All Type of Disease
                SizedBox(
                  height: getScreenHeight(context) * 0.35,
                  child: GridView.count(
                    crossAxisCount: 3, // 3 columns
                    childAspectRatio: (getScreenWidth(context) * 0.35) /
                        (getScreenHeight(context) *
                            0.19), // Adjust aspect ratio
                    children: List.generate(imageList.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(SkinTonePrediction());
                        },
                        onLongPress: () {
                          _showPopup(
                              context,
                              contentMap[index] ?? 'No details available',
                              skinDiseases[index]);
                        },
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageList[index]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    }),
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context, String content, String disease) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${disease} Skin Disease Details'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
