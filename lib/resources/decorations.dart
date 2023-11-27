import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

BoxDecoration regularRoundedDecoration({
  double? radius,
  Color? backgroundColor,
  Color? strokeColor,
}) {
  return BoxDecoration(
    color: backgroundColor,
    border: Border.all(color: strokeColor ?? Colors.transparent, width: 1.rSp),
    borderRadius: BorderRadius.circular(radius ?? 8.rSp),
  );
}
