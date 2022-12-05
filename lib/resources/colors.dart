import 'package:flutter/material.dart';

class AppColors {
  static Color purpleBlue = const Color(0xFF6A13F4);
  static Color blueViolet = const Color(0xFF8541F6);
  static Color lightViolet = const Color(0xFFCFB4FC);
  static Color lightVioletTwo = const Color(0xFFF0E7FE);
  static Color white = const Color(0xFFFFFFFF);
  static Color red = const Color(0xFFF44336);
  static Color green = const Color(0xFF5C9E1E);
  static Color black = const Color(0xFF000000);
  static Color canaryYellow = const Color(0xFFFAF84F);
  static Color manilla = const Color(0xFFFBFA92);
  static Color whiteSmoke = const Color(0xFFF4F5F7);
  static Color smokeyGrey = const Color(0xFF727272);
  static Color lightGrey = const Color(0xFFD9D9D9);
  static Color blackCow = const Color(0xFF4A4A4A);
  static Color blueChalk = const Color(0xFFF0E7FE);
  static Color coolGrey = const Color(0xFF9C9C9C);
  static Color lightSalmon = const Color(0xFFFBA592);
  static Color warmRed = const Color(0xFFFF2E00);
  static Color pearl = const Color(0xFFF3F1F1);
}

Color getCheckboxColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return AppColors.purpleBlue;
  }
  return AppColors.purpleBlue;
}
