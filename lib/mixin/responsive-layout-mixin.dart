import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rpskindisease/utils/constants/dimensions.dart';

mixin ResponsiveLayoutMixin {
  static const double padding = 9.0;
  static const double borderRadius = 8.0;
  static const double fontSize = 14.0;
  static const int animationDuration = 500;

  double getPadding(double times) => padding * times;
  double getRadius(double times) => borderRadius * times;
  double getFontSize(double times) => fontSize * times;
  double getBorderRadius(double times) => borderRadius * times;
  int getAnimationDuration() => animationDuration;

  double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  double getContentWidth(BuildContext context) =>
      getScreenWidth(context) * Dimensions.screenWidthFactor;

  double getPaddingToMatchContentWidth(BuildContext context) =>
      (getScreenWidth(context) - getContentWidth(context)) / 2;

  double getSoftKeyboardHeight(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom;

  double getStatusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  double getBottomNavigationHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  double getContentHeight(
    BuildContext context, {
    bool safeAreaPadding = true,
    bool bottomNavigationHeight = true,
    bool keyboardHeight = true,
    bool appBarHeight = false,
  }) {
    var heightToReturn = getScreenHeight(context);

    if (safeAreaPadding) {
      heightToReturn -= getStatusBarHeight(context);
    }

    if (keyboardHeight) {
      heightToReturn += getSoftKeyboardHeight(context);
    }

    if (bottomNavigationHeight) {
      heightToReturn -= getBottomNavigationHeight(context);
    }

    if (appBarHeight) {
      heightToReturn -= kToolbarHeight;
    }

    return heightToReturn;
  }
}
