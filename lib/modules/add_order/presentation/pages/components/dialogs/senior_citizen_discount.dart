import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/counter_view.dart';

class SeniorCitizenDiscountView extends StatefulWidget {
  final int? initialCitizenCount;
  final int? initialCustomerCount;
  final int? citizenMaxCount;
  final Function(int) onCitizenChanged;
  final Function(int) onCustomerChanged;
  final bool isItemDiscount;

  const SeniorCitizenDiscountView({
    Key? key,
    this.initialCitizenCount,
    this.initialCustomerCount,
    this.citizenMaxCount,
    required this.onCitizenChanged,
    required this.onCustomerChanged,
    required this.isItemDiscount,
  }) : super(key: key);

  @override
  State<SeniorCitizenDiscountView> createState() => _SeniorCitizenDiscountViewState();
}

class _SeniorCitizenDiscountViewState extends State<SeniorCitizenDiscountView> {
  late int _citizenCount;
  late int _citizenMaxCount;
  late int _customerCount;
  late int _customerMaxCount;

  @override
  void initState() {
    if (widget.isItemDiscount) {
      _citizenCount = widget.initialCitizenCount ?? 1;
      _customerCount = widget.initialCustomerCount ?? 1;
      _citizenMaxCount = widget.citizenMaxCount ?? 1;
    } else {
      _citizenCount = widget.initialCitizenCount ?? 1;
      _customerCount = widget.initialCustomerCount ?? 1;
      _citizenMaxCount = widget.initialCustomerCount ?? 1;
    }
    _customerMaxCount = 10000;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.isItemDiscount ? AppStrings.enter_number_of_items_for_sc.tr() : AppStrings.enter_number_of_sc.tr(),
          style: regularTextStyle(
            fontSize: AppFontSize.s12.rSp,
            color: AppColors.greyDarker,
          ),
        ),
        SizedBox(height: AppSize.s8.rh),
        Row(
          children: [
            CounterView(
              enabled: true,
              count: _citizenCount,
              minCount: 1,
              maxCount: _citizenMaxCount,
              onChanged: (count) {
                setState(() {
                  _citizenCount = count;
                  widget.onCitizenChanged(_citizenCount);
                });
              },
            ),
          ],
        ),
        if (!widget.isItemDiscount)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: const Divider(),
              ),
              Text(
                AppStrings.enter_number_of_total_customer.tr(),
                style: regularTextStyle(
                  fontSize: AppFontSize.s12.rSp,
                  color: AppColors.greyDarker,
                ),
              ),
              SizedBox(height: AppSize.s8.rh),
              Row(
                children: [
                  CounterView(
                    enabled: true,
                    count: _customerCount,
                    minCount: 1,
                    maxCount: _customerMaxCount,
                    onChanged: (count) {
                      setState(() {
                        _citizenMaxCount = count;
                        _customerCount = count;
                        widget.onCustomerChanged(count);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
