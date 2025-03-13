import 'package:flutter/material.dart';
import 'package:rpskindisease/widgets/AuthReusable/Button.dart';
import 'package:rpskindisease/widgets/loader/custom_loader.dart';

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;

  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CustomWaveLoader())
        : CustomElevatedButton(
            onPressed: onPressed,
            label: label,
          );
  }
}
