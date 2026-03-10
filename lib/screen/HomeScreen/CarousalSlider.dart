// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';

class CustomCarouselSlider extends StatelessWidget with ResponsiveLayoutMixin {
  /// When set, the carousel uses this height (e.g. when embedded in HomeScreen).
  final double? height;

  CustomCarouselSlider({Key? key, this.height}) : super(key: key);

  final List<String> imageList = [
    'assets/images/slider 1.jpeg',
    'assets/images/slider 2.jpeg',
    'assets/images/slider 3.jpeg',
    'assets/images/slider 4.jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    final double carouselHeight = height ?? getScreenHeight(context);
    return SizedBox(
      height: carouselHeight,
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          height: carouselHeight,
          aspectRatio: 16 / 9,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.88,
        ),
        items: imageList.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
