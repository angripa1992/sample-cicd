import 'package:flutter/material.dart';

import 'fonts.dart';

TextStyle _getTextStyle(
  double fontSize,
  String fontFamily,
  FontWeight fontWeight,
  Color color,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

TextStyle getRegularTextStyle({
  double fontSize = AppFontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    AppFonts.fontFamilyAeonik,
    AppFontWeight.regular,
    color,
  );
}

TextStyle getLightTextStyle({
  double fontSize = AppFontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    AppFonts.fontFamilyAeonik,
    AppFontWeight.light,
    color,
  );
}

TextStyle getBoldTextStyle({
  double fontSize = AppFontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    AppFonts.fontFamilyAeonik,
    AppFontWeight.bold,
    color,
  );
}

TextStyle getMediumTextStyle({
  double fontSize = AppFontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    AppFonts.fontFamilyAeonik,
    AppFontWeight.medium,
    color,
  );
}
