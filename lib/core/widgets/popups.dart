import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/message_notifier.dart';

void showNotifierDialog(BuildContext context, String message, bool isSuccess, {String? title, Function()? onDismiss}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (childContext) => MessageNotifier(
      title: title,
      message: message,
      isSuccess: isSuccess,
      onDismiss: onDismiss,
    ),
  ).then(
    (value) {
      if (onDismiss != null) {
        onDismiss();
      }
    },
  );
}
