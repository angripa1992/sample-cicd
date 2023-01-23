import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

extension SizeExtension on num {
  static final _screenSizes = ScreenSizes();

  ///* Get the `width` by percentage of screen width `10.w`
  double get w => _screenSizes.getWidth(this);

  ///* Get the `height` by percentage of screen height `10.h`
  double get h => _screenSizes.getHeight(this);

  ///* Get the `relative width` by pixels of screen width
  double get rw => _screenSizes.getRelativeWidth(this);

  ///* Get the `relative height` by pixels of screen height
  double get rh => _screenSizes.getRelativeHeight(this);

  ///* Get the responsive `font-size` for based on scale and screen size
  double get rSp => _screenSizes.getRelativeFontSize(this);
}

class ScreenSizes {
  static final ScreenSizes _screenSizes = ScreenSizes._();

  ScreenSizes._();

  factory ScreenSizes() => _screenSizes;

  static late double screenWidth;
  static late double screenHeight;
  static late double statusBarHeight;

  final Size _designSize = const Size(360, 640);

  Size get designSize => _designSize;

  double get scaleWidth => screenWidth / designSize.width;

  double get scaleHeight => screenHeight / designSize.height;

  double getRelativeWidth(num size) => size * scaleWidth;

  double getRelativeHeight(num size) => size * scaleHeight;

  double getRelativeFontSize(num size) => size * min(scaleWidth, scaleHeight);

  double getWidth(num size) => size * screenWidth / 100;

  double getHeight(num size) => size * screenHeight / 100;

  static bool get isTablet => 100.w > 600;
}
