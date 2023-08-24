import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFF5A57EB);
  static Color primaryLighter = const Color(0xFFb3b2f7);
  static Color primaryLight = const Color(0xFF8b8ae6);
  static Color primaryDark = const Color(0xFF403fab);
  static Color primaryDarker = const Color(0xFF172b4d);

  static Color red = const Color(0xFFEB5757);
  static Color redDark = const Color(0xFFED2B2B);
  static Color redLight = const Color(0xFFE66A6A);
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

  static Color white = const Color(0xFFFFFFFF);

  static Color black = const Color(0xFF262626);
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
