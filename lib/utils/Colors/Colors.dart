// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';

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

final primaryBackgroundColor = HexColor("#ffffff");
final authTextFormFillColor = HexColor("#fffded");
final primaryButtonColor = HexColor("#ef9e5c");
final textFieldBorderColor = HexColor("#ef9e5c");
