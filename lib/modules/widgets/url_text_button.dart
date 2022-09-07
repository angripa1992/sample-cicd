import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

class UrlTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final FontWeight? fontWeight;

  const UrlTextButton({Key? key, required this.onPressed, required this.text, this.color, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.Aeonik,
          color: color ?? AppColors.purpleBlue,
          fontSize: AppSize.s16.rSp,
          fontStyle: FontStyle.normal,
          fontWeight: fontWeight ?? AppFontWeight.regular,
            decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
