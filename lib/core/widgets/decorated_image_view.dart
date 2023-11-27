import 'package:flutter/material.dart';

class DecoratedImageView extends StatelessWidget {
  final Widget? iconWidget;
  final Icon? icon;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final void Function()? onTap;

  const DecoratedImageView({
    super.key,
    this.iconWidget,
    this.icon,
    this.padding,
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: decoration?.color ?? Colors.transparent,
      borderRadius: decoration?.borderRadius?.resolve(null),
      child: InkWell(
        borderRadius: decoration?.borderRadius?.resolve(null),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: decoration?.color ?? Colors.transparent,
            border: decoration?.border,
            borderRadius: decoration?.borderRadius?.resolve(null),
            boxShadow: decoration?.boxShadow,
          ),
          alignment: Alignment.center,
          child: buildWidget(),
        ),
      ),
    );
  }

  Widget buildWidget() {
    if (iconWidget == null && icon == null) {
      throw Exception("A WIDGET or an ICON must be provided");
    } else {
      return Center(
        child: iconWidget ?? icon,
      );
    }
  }
}
