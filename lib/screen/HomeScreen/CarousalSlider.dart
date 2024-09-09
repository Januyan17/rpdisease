// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';

class CustomCarouselSlider extends StatelessWidget with ResponsiveLayoutMixin {
  final List<String> imageList = [
    'https://www.makatimed.net.ph/wp-content/uploads/2022/01/2d.png',
    'https://www.kidshealth.org.nz/sites/kidshealth/files/images/HLNZ_Postcards_English_P%5B1%5D_Page_1_2.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxGeYyX8bIy_pBsey-IrqNU1-XJeLEmB7mSA&s',
    'https://img.freepik.com/free-vector/flat-hand-drawn-oily-skin-problems-infographic-template_23-2148857966.jpg',
    'https://img.freepik.com/premium-vector/different-types-skin-problems-vector-illustrations-set_778687-747.jpg?semt=ais_hybrid',
    'https://st.depositphotos.com/4320929/61647/v/450/depositphotos_616470818-stock-illustration-woman-towel-head-spa-skin.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Image Carousel Slider"),
      //   backgroundColor: Colors.blueAccent,
      // ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            height: getScreenHeight(context),
            aspectRatio: 16 / 9,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
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
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
