import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';

BoxDecoration regularRoundedDecoration({
  double? radius,
  Color? color,
}) {
  return BoxDecoration(
    border: Border.all(color: color ?? AppColors.greenDark, width: 1.rSp),
    borderRadius: BorderRadius.circular(radius ?? 8.rSp),
  );
}
