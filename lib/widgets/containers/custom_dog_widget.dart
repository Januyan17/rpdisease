import 'package:flutter/material.dart';
import 'package:rpskindisease/utils/spacers/screen_size_calculator.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';

class CustomDogCardWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color? containerColor;
  final String? characters;

  const CustomDogCardWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.containerColor,
    this.characters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        height: ScreenUtils.height * 0.25,
        width: ScreenUtils.height * 0.2,
        decoration: BoxDecoration(
          color: containerColor ?? const Color.fromARGB(255, 245, 224, 192),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagePath,
                height: ScreenUtils.height * 0.15, // Adjusted height
                width: ScreenUtils.width * 0.35, // Adjusted width
                fit: BoxFit.cover,
              ),
            ),
            ColumnSpacer(0.01),

            // Title & Subtitle
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//! Horizontal Image

class HorizontalImageList extends StatelessWidget {
  final List<String> imageUrls = [
    'https://th.bing.com/th/id/OIP.yuYto9g41BDnIt-LwK5N6gHaHx?rs=1&pid=ImgDetMain',
    'https://th.bing.com/th/id/OIP.yuYto9g41BDnIt-LwK5N6gHaHx?rs=1&pid=ImgDetMain',
    'https://th.bing.com/th/id/OIP.yuYto9g41BDnIt-LwK5N6gHaHx?rs=1&pid=ImgDetMain',
    'https://th.bing.com/th/id/OIP.yuYto9g41BDnIt-LwK5N6gHaHx?rs=1&pid=ImgDetMain',
    'https://th.bing.com/th/id/OIP.yuYto9g41BDnIt-LwK5N6gHaHx?rs=1&pid=ImgDetMain',
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return (Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: ScreenUtils.height * 0.1,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Container(
              width: ScreenUtils.height * 0.1, // Width of each container
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}
