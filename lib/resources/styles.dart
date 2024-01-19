import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import 'colors.dart';
import 'fonts.dart';

TextStyle _getTextStyle(
  double? fontSize,
  Color? color,
  FontWeight fontWeight,
) {
  return TextStyle(
    fontSize: fontSize ?? AppFontSize.s14.rSp,
    fontFamily: AppFonts.Inter,
    color: color ?? AppColors.black,
    fontWeight: fontWeight,
    letterSpacing: -0.5,
    // height: 1.30,
  );
}

TextStyle regularTextStyle({
  double? fontSize,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    color,
    AppFontWeight.regular,
  );
}

TextStyle lightTextStyle({
  double? fontSize,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    color,
    AppFontWeight.light,
  );
}

TextStyle boldTextStyle({
  double? fontSize,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    color,
    AppFontWeight.bold,
  );
}

TextStyle semiBoldTextStyle({
  double? fontSize,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    color,
    AppFontWeight.semiBold,
  );
}

TextStyle mediumTextStyle({
  double? fontSize,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    color,
    AppFontWeight.medium,
  );
}

TextStyle thinTextStyle({
  double? fontSize,
  Color? color,
}) {
  return _getTextStyle(
    fontSize,
    color,
    AppFontWeight.thin,
  );
}


// Widget getAppBarBackground() {
//   return Container(
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         colors: [
//           const Color(0xFF000000).withOpacity(1.0),
//           const Color(0xFF6A13F4).withOpacity(1.0),
//           const Color(0xFFFAF84F).withOpacity(1.0),
//         ],
//       ),
//     ),
//   );
// }
