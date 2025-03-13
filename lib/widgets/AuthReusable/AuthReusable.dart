// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscure;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool autovalidate;
  final TextInputType? textInputType;

  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.obscure,
    this.prefixIcon,
    this.validator,
    this.autovalidate = false,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        SizedBox(height: 8),
        TextFormField(
          keyboardType: textInputType,
          autovalidateMode: autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          obscureText: obscure,
          controller: controller,
          maxLines: labelText == 'Content' ? 6 : 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: authTextFormFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  BorderSide(color: HexColor("#ef9e5c")), // Purple border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor("#ef9e5c")),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor("#ef9e5c")),
            ),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
