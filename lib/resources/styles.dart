import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import 'colors.dart';
import 'fonts.dart';

TextStyle _getTextStyle(
  double fontSize,
  String fontFamily,
  FontWeight fontWeight,
  Color color,
  FontStyle fontStyle,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}

TextStyle getRegularTextStyle({
  double fontSize = AppFontSize.s12,
  FontStyle fontStyle = FontStyle.normal,
  String fontFamily = AppFonts.Aeonik,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    fontFamily,
    AppFontWeight.regular,
    color,
    fontStyle,
  );
}

TextStyle getLightTextStyle({
  double fontSize = AppFontSize.s12,
  FontStyle fontStyle = FontStyle.normal,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    AppFonts.Aeonik,
    AppFontWeight.light,
    color,
    fontStyle,
  );
}

TextStyle getBoldTextStyle({
  double fontSize = AppFontSize.s12,
  FontStyle fontStyle = FontStyle.normal,
  String fontFamily = AppFonts.Aeonik,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    fontFamily,
    AppFontWeight.bold,
    color,
    fontStyle
  );
}

TextStyle getMediumTextStyle({
  double fontSize = AppFontSize.s12,
  FontStyle fontStyle = FontStyle.normal,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    AppFonts.Aeonik,
    AppFontWeight.medium,
    color,
    fontStyle,
  );
}

TextStyle getAppBarTextStyle() {
  return getRegularTextStyle(
    fontFamily: AppFonts.Abel,
    color: AppColors.white,
    fontSize: AppFontSize.s17.rSp,
  );
}

Widget getAppBarBackground() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFF000000).withOpacity(1.0),
          const Color(0xFF6A13F4).withOpacity(1.0),
          const Color(0xFFFAF84F).withOpacity(1.0),
        ],
      ),
    ),
  );
}
