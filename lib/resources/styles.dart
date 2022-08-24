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
    AppFontConstants.fontFamily,
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
    AppFontConstants.fontFamily,
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
    AppFontConstants.fontFamily,
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
    AppFontConstants.fontFamily,
    AppFontWeight.medium,
    color,
  );
}
