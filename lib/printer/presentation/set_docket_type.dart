import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_checkbox.dart';
import 'package:klikit/core/widgets/kt_counter.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

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
  bool? _kitchenCopyChecked;
  bool? _customerCopyChecked;
  int? _kitchenCopyCount;
  int? _customerCopyCount;

  @override
  void initState() {
    _kitchenCopyChecked = widget.initKitchenCopyEnabled;
    _customerCopyChecked = widget.initCustomerCopyEnabled;
    _kitchenCopyCount = widget.initKitchenCopyCount;
    _customerCopyCount = widget.initCustomerCopyCount;
    super.initState();
  }

  void _changeKitchenCopyEnabled(bool checked) {
    setState(() {
      _kitchenCopyChecked = checked;
      widget.changeKitchenCopyEnabled(_kitchenCopyChecked!);
    });
  }

  void _changeKitchenCopyCount(int count) {
    _kitchenCopyCount = count;
    widget.changeKitchenCopyCount(_kitchenCopyCount!);
  }

  void _changeCustomerCopyCount(int count) {
    _customerCopyCount = count;
    widget.changeCustomerCopyCount(_customerCopyCount!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s12.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.set_docket_type.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: KTCheckbox(
                  onChanged: _changeKitchenCopyEnabled,
                  name: AppStrings.kitchen.tr(),
                  checked: _kitchenCopyChecked!,
                  primaryColor: AppColors.primaryP300,
                ),
              ),
              KTCounter(
                enabled: _kitchenCopyChecked!,
                count: _kitchenCopyCount!,
                onChanged: _changeKitchenCopyCount,
                minCount: 0,
                maxCount: 5,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: KTCheckbox(
                  enabled: false,
                  onChanged: _changeKitchenCopyEnabled,
                  name: AppStrings.customer.tr(),
                  checked: _customerCopyChecked!,
                  primaryColor: AppColors.primaryP300,
                ),
              ),
              KTCounter(
                enabled: _customerCopyChecked!,
                count: _customerCopyCount!,
                onChanged: _changeCustomerCopyCount,
                minCount: 1,
                maxCount: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
