import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFF5A57EB);
  static Color primaryLighter = const Color(0xFFF0E7FE);
  static Color primaryLight = const Color(0xFFC29EFA);
  static Color primaryDark = const Color(0xFF403fab);
  static Color primaryDarker = const Color(0xFF172b4d);

  static Color red = const Color(0xFFEB5757);
  static Color redDark = const Color(0xFFED2B2B);
  static Color redLight = const Color(0xFFE66A6A);
  static Color redLighter = const Color(0xFFFEECEF);
  static Color redPure = const Color(0xFFFF0000);

  static Color green = const Color(0xFF27AE60);
  static Color greenLight = const Color(0xFF02ED65);
  static Color greenDark = const Color(0xFF00943E);

  static Color yellowDark = const Color(0xFFFFA133);
  static Color yellowDarker = const Color(0xFFf48300);

  static Color blue = const Color(0xFF0468E4);
  static Color blueDark = const Color(0xFF0353b6);

  static Color grey = const Color(0xFFEEEEEE);
  static Color greyDarker = const Color(0xFF8d97ad);
  static Color greyDark = const Color(0xFFCFD8DC);
  static Color greyLight = const Color(0xFFf4f5f7);
  static Color greyLighter = const Color(0xFFfafafa);
  static Color greyBright = const Color(0xFFEBEBEB);
  static Color graniteGrey = const Color(0xFF666666);
  static Color errorR300 = const Color(0xFFF43F5E);

  static Color white = const Color(0xFFFFFFFF);

  static Color black = const Color(0xFF262626);
  static Color neutralB500 = const Color(0xFF3B3B3B);
  static Color neutralB700 = const Color(0xFF1C1C1C);
  static Color primaryP300 = const Color(0xFF6A13F4);
  static Color neutralB600 = const Color(0xFF2E2E2E);
  static Color successG600 = const Color(0xFF16B050);
  static Color neutralB40 = const Color(0xFFDEDEDE);
  static Color neutralB20 = const Color(0xFFF5F5F5);
  static Color spanishGrey = const Color(0xFF949494);
}

Color getCheckboxColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return AppColors.primary;
  }
  return AppColors.primary;
}
