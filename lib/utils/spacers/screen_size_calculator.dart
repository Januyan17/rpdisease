// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// Screen size breakpoints for different device types.
const double SMALL_SCREEN_HEIGHT = 560.0;
const double SMALL_SCREEN_WIDTH = 320.0;

const double MEDIUM_SCREEN_HEIGHT = 820.0;
const double MEDIUM_SCREEN_WIDTH = 420.0;

const double LARGE_SCREEN_HEIGHT = 900.0;
const double LARGE_SCREEN_WIDTH = 420.0;

/// Utility class for managing screen dimensions and responsive UI scaling.
// class ScreenUtils {
//   static Size? screenSize;
//   static MediaQueryData? mqData;

//   // Default UI component dimensions.
//   static double containerBoxHeight = 410.0;
//   static double topBarHeight = 152.0;
//   static double bottomBarHeight = 95.0;

//   /// Retrieves safe area padding (top + bottom).
//   static double get safeArea => mqData?.padding.vertical ?? 0;

//   /// Screen size properties.
//   static Size? get size => screenSize;
//   static double get height => size?.height ?? 0;
//   static double get width => size?.width ?? 0;

//   /// Default padding for pages.
//   static double get defaultPagePadding => width * 0.08;
// }

class ScreenUtils {
  static MediaQueryData? mqData;

  /// Initialize `ScreenUtils` with the context.
  /// Call this method in the `build` method of your app's main widget or any widget that
  /// needs screen-related calculations.
  static void init(BuildContext context) {
    mqData = MediaQuery.of(context);
  }

  /// Screen size properties.
  static Size get size => mqData?.size ?? const Size(0, 0);
  static double get height => size.height;
  static double get width => size.width;

  /// Safe area padding properties.
  static double get safeAreaVertical => mqData?.padding.vertical ?? 0;
  static double get safeAreaHorizontal => mqData?.padding.horizontal ?? 0;
  static double get safeAreaTop => mqData?.padding.top ?? 0;
  static double get safeAreaBottom => mqData?.padding.bottom ?? 0;

  /// Responsive height and width scaling.
  static double scaleHeight(double inputHeight) =>
      inputHeight * height / 812; // Assuming base height is 812.
  static double scaleWidth(double inputWidth) =>
      inputWidth * width / 375; // Assuming base width is 375.

  /// Responsive font scaling.
  static double scaleFont(double fontSize) => fontSize * (width / 375);

  /// Responsive UI component dimensions.
  static double get containerBoxHeight =>
      scaleHeight(410.0); // Adjust proportionally
  static double get topBarHeight => scaleHeight(152.0);
  static double get bottomBarHeight => scaleHeight(95.0);

  /// Default padding for pages.
  static double get defaultPagePadding => scaleWidth(16.0);

  /// Utility to get percentage of screen width.
  static double screenWidthPercentage(double percentage) =>
      width * (percentage / 100);

  /// Utility to get percentage of screen height.
  static double screenHeightPercentage(double percentage) =>
      height * (percentage / 100);
}

/// Calculates a height value adjusted for the screen size.
///
/// - [context]: Build context for accessing screen dimensions.
/// - [height]: Original height value.
/// - Returns the calculated height.
double getCalculatedHeight(BuildContext context, double height) {
  const double designScreenHeight = 812.0;
  final double screenHeight = ScreenUtils.height;

  // printLog("Screen height: $screenHeight");

  if (screenHeight <= 480.0) {
    return (height / designScreenHeight) * screenHeight;
  } else if (screenHeight <= 667.0) {
    return height * 0.9;
  }
  return height;
}

/// Calculates a width value adjusted for the screen size.
///
/// - [context]: Build context for accessing screen dimensions.
/// - [width]: Original width value.
/// - Returns the calculated width.
double getCalculatedWidth(BuildContext context, double width) {
  final double screenWidth = ScreenUtils.width;

  if (screenWidth <= 320.0) {
    return width * 0.76;
  } else if (screenWidth <= 375.0) {
    return width * 0.76;
  }
  return width;
}

/// Adjusts size based on the screen type (small, medium, large).
///
/// - [context]: Build context for accessing screen dimensions.
/// - [originalSize]: Default size.
/// - [sm], [md], [lg]: Optional sizes for small, medium, and large screens.
/// - Returns the adjusted size.
double setSizeFromScreenType(
  BuildContext context,
  double originalSize, {
  double? sm,
  double? md,
  double? lg,
}) {
  onScreenSize(
    context,
    onSmallScreen: (h, w) {
      if (sm != null) originalSize = sm;
    },
    onMediumScreen: (h, w) {
      if (md != null) originalSize = md;
    },
    onLargeScreen: (h, w) {
      if (lg != null) originalSize = lg;
    },
  );
  return originalSize;
}

/// Executes callbacks based on screen size category.
///
/// - [context]: Build context for accessing screen dimensions.
/// - [size]: Optional predefined size (used if context is null).
/// - [onSmallScreen], [onMediumScreen], [onLargeScreen]:
///   Callbacks for handling different screen sizes.
void onScreenSize(
  BuildContext? context, {
  Size? size,
  Function(double height, double width)? onSmallScreen,
  Function(double height, double width)? onMediumScreen,
  Function(double height, double width)? onLargeScreen,
}) {
  if (context == null && size == null) {
    throw Exception("Either context or size must be provided!");
  }

  size ??= MediaQuery.of(context!).size;
  final double width = size.width;
  final double height = size.height;

  if (width <= SMALL_SCREEN_WIDTH &&
      height <= SMALL_SCREEN_HEIGHT &&
      onSmallScreen != null) {
    onSmallScreen(height, width);
  } else if (width <= MEDIUM_SCREEN_WIDTH &&
      height <= MEDIUM_SCREEN_HEIGHT &&
      onMediumScreen != null) {
    onMediumScreen(height, width);
  } else if (onLargeScreen != null) {
    onLargeScreen(height, width);
  }
}
