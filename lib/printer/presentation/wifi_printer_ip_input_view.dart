import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/labeled_textfield.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

class WifiPrinterIPInputView extends StatefulWidget {
  final Function(String) onSetIP;

  const WifiPrinterIPInputView({super.key, required this.onSetIP});

  @override
  State<WifiPrinterIPInputView> createState() => _WifiPrinterIPInputViewState();
}

class _WifiPrinterIPInputViewState extends State<WifiPrinterIPInputView> {
  final _textController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.rSp),
                color: AppColors.neutralB20,
              ),
              padding: EdgeInsets.all(4.rSp),
              child: const Icon(Icons.wifi),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rw),
                child: Text(
                  'Connect to Wi-Fi Printer',
                  style: semiBoldTextStyle(
                    color: AppColors.neutralB700,
                    fontSize: 18.rSp,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.clear, color: AppColors.neutralB700),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.rh),
          child: Form(
            key: _key,
            child: LabeledTextField(
              label: 'Printer IP Address',
              controller: _textController,
              inputType: TextInputType.number,
              hintText: '101.168.01.07',
              validation: (String? text) {
                if (_isValidIPv4(text ?? '')) {
                  return null;
                } else {
                  return 'Please enter a valid IP address';
                }
              },
            ),
          ),
        ),
        KTButton(
          controller: KTButtonController(
            label: AppStrings.connect.tr(),
          ),
          labelStyle: mediumTextStyle(
            color: AppColors.white,
            fontSize: 14.rSp,
          ),
          backgroundDecoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.rSp),
          ),
          onTap: () {
            if (_key.currentState!.validate()) {
              widget.onSetIP(_textController.text.trim());
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  bool _isValidIPv4(String input) {
    const ipv4Pattern = r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';
    final RegExp regex = RegExp(ipv4Pattern);
    return regex.hasMatch(input);
  }
}
