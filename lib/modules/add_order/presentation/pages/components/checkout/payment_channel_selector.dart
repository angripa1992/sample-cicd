import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_radio_group.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/values.dart';

class PaymentChannelSelector extends StatelessWidget {
  final List<KTRadioValue> values;
  final int? selectedChannelId;
  final Function(KTRadioValue) onChannelChanged;

  const PaymentChannelSelector({
    super.key,
    required this.values,
    required this.selectedChannelId,
    required this.onChannelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: values.map((value) {
        return InkWell(
          onTap: () {
            onChannelChanged(value);
          },
          child: Container(
              padding: EdgeInsets.all(AppSize.s12.rSp),
              margin: EdgeInsets.all(AppSize.s4.rSp),
              decoration: regularRoundedDecoration(
                radius: AppSize.s8.rSp,
                backgroundColor: selectedChannelId == value.id ? AppColors.neutralB20 : AppColors.white,
                strokeColor: selectedChannelId == value.id ? AppColors.primaryP300 : AppColors.neutralB200,
              ),
              child: Text(value.title)),
        );
      }).toList(),
    );
  }
}
