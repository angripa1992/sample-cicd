import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/labeled_textfield.dart';

class WifiPrinterDeviceView extends StatefulWidget {
  const WifiPrinterDeviceView({super.key});

  @override
  State<WifiPrinterDeviceView> createState() => _WifiPrinterDeviceViewState();
}

class _WifiPrinterDeviceViewState extends State<WifiPrinterDeviceView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(label: 'Printer IP Address', controller: _textController),
      ],
    );
  }
}
