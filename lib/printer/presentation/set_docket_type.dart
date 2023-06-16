import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/printer/presentation/printer_setting_checkbox.dart';

import '../../app/constants.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import 'docket_counter_view.dart';

class SetDocketType extends StatefulWidget {
  final bool initKitchenCopyEnabled;
  final bool initCustomerCopyEnabled;
  final int initKitchenCopyCount;
  final int initCustomerCopyCount;
  final Function(bool) changeKitchenCopyEnabled;
  final Function(int) changeKitchenCopyCount;
  final Function(int) changeCustomerCopyCount;

  const SetDocketType({
    Key? key,
    required this.initKitchenCopyEnabled,
    required this.initCustomerCopyEnabled,
    required this.initKitchenCopyCount,
    required this.initCustomerCopyCount,
    required this.changeKitchenCopyEnabled,
    required this.changeKitchenCopyCount,
    required this.changeCustomerCopyCount,
  }) : super(key: key);

  @override
  State<SetDocketType> createState() => _SetDocketTypeState();
}

class _SetDocketTypeState extends State<SetDocketType> {
  bool? _kitchenCopyEnabled;
  bool? _customerCopyEnabled;
  int? _kitchenCopyCount;
  int? _customerCopyCount;

  @override
  void initState() {
    _kitchenCopyEnabled = widget.initKitchenCopyEnabled;
    _customerCopyEnabled = widget.initCustomerCopyEnabled;
    _kitchenCopyCount = widget.initKitchenCopyCount;
    _customerCopyCount = widget.initCustomerCopyCount;
    super.initState();
  }

  void _changeKitchenCopyEnabled(bool enabled) {
    setState(() {
      _kitchenCopyEnabled = enabled;
      widget.changeKitchenCopyEnabled(_kitchenCopyEnabled!);
    });
  }

  void _changeKitchenCopyCount(int count) {
    setState(() {
      _kitchenCopyCount = count;
      widget.changeKitchenCopyCount(_kitchenCopyCount!);
    });
  }

  void _changeCustomerCopyCount(int count) {
    setState(() {
      _customerCopyCount = count;
      widget.changeCustomerCopyCount(_customerCopyCount!);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(
          right: AppSize.s12.rw,
          left: AppSize.s12.rw,
          top: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.set_docket_type,
              style: getMediumTextStyle(
                color: AppColors.bluewood,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: PrinterSettingCheckbox(
                    enabled: _kitchenCopyEnabled!,
                    onChanged: _changeKitchenCopyEnabled,
                    name: AppStrings.kitchen,
                    willAlwaysChecked: false,
                    activeColor: AppColors.purpleBlue,
                  ),
                ),
                DocketCounterView(
                  enabled: _kitchenCopyEnabled!,
                  count: _kitchenCopyCount!,
                  onChanged: _changeKitchenCopyCount,
                  minCount: 0,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: PrinterSettingCheckbox(
                    enabled: _customerCopyEnabled!,
                    onChanged: _changeKitchenCopyEnabled,
                    name: AppStrings.customer,
                    willAlwaysChecked: true,
                    activeColor: AppColors.dustyGrey,
                  ),
                ),
                DocketCounterView(
                  enabled: _customerCopyEnabled!,
                  count: _customerCopyCount!,
                  onChanged: _changeCustomerCopyCount,
                  minCount: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
