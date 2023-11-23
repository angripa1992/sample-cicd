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
  final BoxDecoration? backgroundDecoration;
  final Color? splashColor;

  const KTButton({
    super.key,
    required this.controller,
    required this.onTap,
    this.prefixWidget,
    this.suffixWidget,
    this.backgroundDecoration,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) => Material(
        color: backgroundDecoration?.color?.withOpacity(controller.isEnabled() ? 1.0 : 0.5) ?? Colors.transparent,
        borderRadius: backgroundDecoration?.borderRadius?.resolve(null),
        child: AbsorbPointer(
          absorbing: controller.enabled == false,
          child: InkWell(
            onTap: onTap,
            borderRadius: backgroundDecoration?.borderRadius?.resolve(null),
            splashColor: splashColor,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.rSp, vertical: 8.rh),
              decoration: BoxDecoration(
                border: backgroundDecoration?.border,
                borderRadius: backgroundDecoration?.borderRadius?.resolve(null),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(visible: controller.loaded == false, child: CircularProgress(size: 16.rSp, strokeWidth: 2.rSp)),
                  Visibility(visible: controller.loaded == false, child: 5.rw.horizontalSpacer()),
                  prefixWidget.setVisibilityWithSpace(endSpace: 5.rw, direction: Axis.horizontal),
                  Text(controller.label, style: regularTextStyle()),
                  suffixWidget.setVisibilityWithSpace(startSpace: 5.rw, direction: Axis.horizontal),
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

  KTButtonController(this.label, this.enabled);

  bool isEnabled() => enabled;

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
