import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

class KTChip extends StatelessWidget {
  final String text;
  final double? borderRadius;
  final Color? strokeColor;
  final Color backgroundColor;
  final EdgeInsets? padding;
  final DecoratedImageView? leadingIcon;
  final DecoratedImageView? trailingIcon;
  final TextStyle? textStyle;

  const KTChip({
    Key? key,
    required this.text,
    this.borderRadius,
    this.strokeColor,
    required this.backgroundColor,
    this.padding,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: strokeColor ?? AppColors.neutralB40),
        borderRadius: BorderRadius.circular(borderRadius ?? AppSize.s60.rSp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) (leadingIcon!),
          if (leadingIcon != null) const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ),
          if (trailingIcon != null) const SizedBox(width: 4),
          if (trailingIcon != null) (trailingIcon!),
        ],
      ),
    );
  }
}
