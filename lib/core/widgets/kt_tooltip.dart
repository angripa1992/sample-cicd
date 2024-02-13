import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/values.dart';

class KTTooltip extends StatelessWidget {
  final String message;
  final Widget? child;

  const KTTooltip({Key? key, required this.message, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      padding: EdgeInsets.all(6.rSp),
      margin: EdgeInsets.symmetric(horizontal: 16.rw),
      message: message,
      child: child ??
          ImageResourceResolver.infoSVG.getImageWidget(
            width: AppSize.s16.rw,
            height: AppSize.s16.rh,
          ),
    );
  }
}
