import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/resources/styles.dart';

class KTButton extends StatelessWidget {
  final KTButtonController controller;
  final Function() onTap;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final TextStyle? labelStyle;
  final BoxDecoration? backgroundDecoration;
  final Color? splashColor;
  final Color? progressPrimaryColor;
  final Color? progressSecondaryColor;
  final double? verticalContentPadding;
  final double? horizontalContentPadding;

  const KTButton({
    super.key,
    required this.controller,
    required this.onTap,
    this.prefixWidget,
    this.suffixWidget,
    this.labelStyle,
    this.backgroundDecoration,
    this.splashColor,
    this.progressPrimaryColor,
    this.progressSecondaryColor,
    this.verticalContentPadding,
    this.horizontalContentPadding,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style = labelStyle ?? regularTextStyle();
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) => Material(
        color: backgroundDecoration?.color?.withOpacity(controller.enabled ? 1.0 : 0.5) ?? Colors.transparent,
        borderRadius: backgroundDecoration?.borderRadius?.resolve(null),
        child: AbsorbPointer(
          absorbing: controller.enabled == false,
          child: InkWell(
            onTap: onTap,
            borderRadius: backgroundDecoration?.borderRadius?.resolve(null),
            splashColor: splashColor,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalContentPadding ?? 2.rw, vertical: verticalContentPadding ?? 8.rh),
              decoration: BoxDecoration(
                border: backgroundDecoration?.border,
                borderRadius: backgroundDecoration?.borderRadius?.resolve(null),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: controller.loaded == false,
                    child: CircularProgress(
                      size: 16.rSp,
                      strokeWidth: 2.rSp,
                      primaryColor: progressPrimaryColor,
                      secondaryColor: progressSecondaryColor,
                    ),
                  ),
                  Visibility(visible: controller.loaded == false, child: 5.horizontalSpacer()),
                  Opacity(opacity: controller.enabled ? 1.0 : 0.5, child: prefixWidget).setVisibilityWithSpace(endSpace: 2, direction: Axis.horizontal),
                  Text(
                    controller.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style.copyWith(color: style.color?.withOpacity(controller.enabled ? 1.0 : 0.5)),
                    textAlign: TextAlign.center,
                  ),
                  suffixWidget.setVisibilityWithSpace(startSpace: 2, direction: Axis.horizontal),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KTButtonController extends ChangeNotifier {
  String label;
  bool enabled;
  bool loaded = true;

  KTButtonController({required this.label, this.enabled = true});

  void setEnabled(bool enabled) {
    this.enabled = enabled;
    notifyListeners();
  }

  void setLoaded(bool loaded) {
    enabled = loaded;
    this.loaded = loaded;

    notifyListeners();
  }
}
