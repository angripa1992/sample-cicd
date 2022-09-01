import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import 'colors.dart';
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

TextStyle getAppBarTextStyle() {
  return getBoldTextStyle(
    color: AppColors.white,
    fontSize: AppFontSize.s17.rSp,
  );
}

Widget getAppBarBackground(){
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