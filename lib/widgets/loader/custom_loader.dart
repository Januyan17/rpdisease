import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rpskindisease/constants/colors.dart';

class CustomWaveLoaderScaffold extends StatelessWidget {
  final double size;

  CustomWaveLoaderScaffold({
    Key? key,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackGroundColor,
      body: Center(
        child: SpinKitWave(
          color: AppColor.primaryButtonBackgroundColor,
          size: size,
          type: SpinKitWaveType.center,
        ),
      ),
    );
  }
}

class CustomWaveLoader extends StatelessWidget {
  final double size;

  CustomWaveLoader({
    Key? key,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Colors.brown,
        size: size,
        type: SpinKitWaveType.center,
      ),
    );
  }
}

class CustomCircleLoader extends StatelessWidget {
  final double size;

  CustomCircleLoader({
    Key? key,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: AppColor.primaryButtonBackgroundColor,
        size: size,
      ),
    );
  }
}
