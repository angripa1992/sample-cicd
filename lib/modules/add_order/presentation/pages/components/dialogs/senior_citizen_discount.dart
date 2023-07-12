import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/counter_view.dart';

class SeniorCitizenDiscountView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter the number of senior citizens in your order',
          style: regularTextStyle(
            fontSize: AppFontSize.s12.rSp,
            color: AppColors.dustyGreay,
          ),
        ),
        SizedBox(height: AppSize.s8.rh),
        Row(
          children: [
            CounterView(
              enabled: true,
              count: initialCitizenCount ?? 1,
              minCount: 1,
              maxCount: citizenMaxCount ?? 100,
              onChanged: onCitizenChanged,
            ),
          ],
        ),
        if (!isItemDiscount)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: const Divider(),
              ),
              Text(
                'Enter the number of other customers in your order',
                style: regularTextStyle(
                  fontSize: AppFontSize.s12.rSp,
                  color: AppColors.dustyGreay,
                ),
              ),
              SizedBox(height: AppSize.s8.rh),
              Row(
                children: [
                  CounterView(
                    enabled: true,
                    count: initialCustomerCount ?? 1,
                    minCount: 1,
                    maxCount: 100,
                    onChanged: onCustomerChanged,
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
