import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
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
    return SizedBox(
      height: 48.rh,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: values.map((value) {
          return InkWell(
            onTap: () {
              onChannelChanged(value);
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 4.rh),
                margin: EdgeInsets.all(AppSize.s4.rSp),
                decoration: regularRoundedDecoration(
                  radius: AppSize.s8.rSp,
                  backgroundColor: selectedChannelId == value.id ? AppColors.neutralB20 : AppColors.white,
                  strokeColor: selectedChannelId == value.id ? AppColors.primaryP300 : AppColors.neutralB200,
                ),
                child: value.logo.isNotNullOrEmpty()
                    ? KTNetworkImage(
                        imageUrl: value.logo!,
                        width: 50.rw,
                        boxShape: BoxShape.rectangle,
                        boxFit: BoxFit.fitWidth,
                        imageBorderWidth: 0,
                        imageBorderColor: Colors.transparent,
                      )
                    : Text(value.title)),
          );
        }).toList(),
      ),
    );
  }
}
