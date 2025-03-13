import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor {
  static Color primaryBlueColor = HexColor("#3682fe");
  static Color primaryWhiteColor = HexColor("#ffffff");
  static Color primaryBlackColor = HexColor("#000000");
  static Color primaryGreyColor = HexColor("#b8b8b8");
  static Color primaryRedColor = HexColor("#fe3636");
  static Color primaryBlueGradientBorderColor = HexColor("#70e9d3");
  static Color primaryGreenBorderColor = HexColor("#74ecbe");
  static Color primaryButtonBackgroundColor = HexColor("#9de6c9");
  static Color primarylightBlueTextColor = HexColor("#cfffff");
  static Color primaryGreenColor = HexColor("#00e676");
  static Color primarySubGreenColor = HexColor("#69f0ae");
  static Color primaryprefixIconColor = HexColor("#7d9794");
  static Color primarysuffixIconColor = HexColor("#a9c6c1");
  static Color scaffoldBgColor =
      AppColor.primarylightBlueTextColor.withOpacity(0.2);
  static Color bottomNavBarBgColor =
      AppColor.primaryBlueGradientBorderColor.withOpacity(0.1);
}

// App Color
Color primaryBlackColor = Colors.black;
Color primaryWhiteColor = Colors.white;
Color primaryGreyColor = HexColor("#7F7F7F");
Color primaryGreenColor = HexColor("#00e676");
Color primaryGreenColor2 = Colors.greenAccent.shade700;
Color primarySubGreenColor = HexColor("#69f0ae");
Color primaryBackGroundColor = HexColor("#e9f5ec");
Color primaryRedColor = Colors.red;

//Home Screen Pale Color

Color paleColor1 = HexColor("ffeeb2");
Color paleColor2 = HexColor("ffccb2");
Color paleColor3 = HexColor("b2e3ff");
Color paleColor4 = HexColor("b2c1ff");
Color paleColor5 = HexColor("ffeeb2");
Color paleColor6 = HexColor("ffb2c2");
Color paleColor7 = HexColor("ffb2ff");

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
