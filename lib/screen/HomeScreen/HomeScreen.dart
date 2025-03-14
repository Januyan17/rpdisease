// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';
import 'package:rpskindisease/screen/HomeScreen/CarousalSlider.dart';
import 'package:rpskindisease/widgets/ScreenWidgets/dogswipewidget.dart';
import 'package:rpskindisease/widgets/containers/custom_dog_widget.dart';

class HomeScreenPage extends StatelessWidget with ResponsiveLayoutMixin {
  HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Home Screen"),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //! Search Bar
                // Center(
                //   child: Container(
                //     color: Colors.red,
                //     height: getScreenHeight(context) * 0.08,
                //     width: getScreenWidth(context) * 0.8,
                //     child: CustomSearchBar(),
                //   ),
                // ),
                SizedBox(
                  height: getScreenHeight(context) * 0.05,
                ),
                const Text(
                  "Transforming Dog Skin Disease Diagnosis with Machine Learning",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "A New Era in veterinary dermatologist",
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
                const Text(
                  "My Category",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                HorizontalImageList(),
                // SizedBox(
                //   height: getScreenHeight(context) * 0.01,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "My Pets",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    TextButton(onPressed: () {}, child: Text("More"))
                  ],
                ),
                SizedBox(
                    // height: getScreenHeight(context) * 0.01,
                    ),
                DogSwipeScreen(),

                //! All Type of Disease
                // SizedBox(
                //   height: getScreenHeight(context) * 0.35,
                //   child: GridView.count(
                //     crossAxisCount: 3, // 3 columns
                //     childAspectRatio: (getScreenWidth(context) * 0.35) /
                //         (getScreenHeight(context) *
                //             0.19), // Adjust aspect ratio
                //     children: List.generate(imageList.length, (index) {
                //       return GestureDetector(
                //         onTap: () {
                //           Get.to(SkinTonePrediction());
                //         },
                //         onLongPress: () {
                //           _showPopup(
                //               context,
                //               contentMap[index] ?? 'No details available',
                //               skinDiseases[index]);
                //         },
                //         child: Container(
                //           margin: EdgeInsets.all(8.0),
                //           decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: NetworkImage(imageList[index]),
                //               fit: BoxFit.cover,
                //             ),
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //         ),
                //       );
                //     }),
                //     shrinkWrap: true,
                //     physics:
                //         NeverScrollableScrollPhysics(), // Disable scrolling
                //   ),
                // ),
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
