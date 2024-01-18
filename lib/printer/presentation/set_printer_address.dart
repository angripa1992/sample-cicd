import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import '../data/dockets_fonts.dart';

class SetPrinterAddressText extends StatefulWidget {

  final Function(String) onSaved;

  final String address;

  const SetPrinterAddressText(
      {Key? key,required this.address, required this.onSaved})
      : super(key: key);

  @override
  State<SetPrinterAddressText> createState() => _SetPrinterAddressText();
}

class _SetPrinterAddressText extends State<SetPrinterAddressText> {
  String? _address;

  @override
  void initState() {
    _address = widget.address ;
    super.initState();
  }
  void _setIpAddress(String val) {
    setState(() {
      _address = val;
      widget.onSaved(_address!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s12.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set Printer IP',
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            SizedBox(height: AppSize.s8.rh),
            TextFormField(
              initialValue: _address,
              decoration: InputDecoration(
                icon: Icon(Icons.network_wifi),
                hintText: 'Printer Address',
              ),
              onChanged: _setIpAddress,


            ),
          ],
        ),
      ),
    );
  }
}
