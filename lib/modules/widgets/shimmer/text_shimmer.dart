import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/strings.dart';
import '../../../resources/styles.dart';

class TextShimmer extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;
  final String text;
  final TextStyle textStyle;

  const TextShimmer(
      {Key? key,
      required this.baseColor,
      required this.highlightColor,
      required this.text,
      required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      enabled: true,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
