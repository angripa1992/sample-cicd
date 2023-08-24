import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primaryColor: AppColors.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
