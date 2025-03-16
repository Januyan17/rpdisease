// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final bool readOnly;
  final bool autovalidate;
  final String? Function(String?)? validator;

  const CustomDropdown({
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.hintText = "",
    this.value,
    this.readOnly = false,
    this.autovalidate = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          validator: validator,
          autovalidateMode: autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(fontSize: 15, color: Colors.black45),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: authTextFormFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor("#ef9e5c")),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor("#ef9e5c")),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor("#ef9e5c")),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: readOnly ? null : onChanged,
        ),
      ],
    );
  }
}
