import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/styles.dart';

class KTButton extends StatelessWidget {
  final KTButtonController controller;
  final Function() onTap;
  final BoxDecoration? backgroundDecoration;

  const KTButton({
    super.key,
    required this.controller,
    required this.onTap,
    this.backgroundDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) => AbsorbPointer(
        absorbing: controller.enabled == false,
        child: InkWell(
          onTap: onTap,
          borderRadius: backgroundDecoration?.borderRadius?.resolve(null),
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
                Visibility(visible: controller.loaded == false, child: const CircularProgressIndicator()),
                SizedBox(width: 5.rw),
                Text(
                  controller.label,
                  style: regularTextStyle(),
                )
              ],
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
