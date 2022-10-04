import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/environment_variables.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../app/di.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';

class DeliveryPlatformItem extends StatefulWidget {
  final Provider provider;
  final Function(bool, Provider) onChange;

  const DeliveryPlatformItem(
      {Key? key, required this.provider, required this.onChange})
      : super(key: key);

  @override
  State<DeliveryPlatformItem> createState() => _DeliveryPlatformItemState();
}

class _DeliveryPlatformItemState extends State<DeliveryPlatformItem> {
  final envVariables = getIt.get<EnvironmentVariables>();
  bool? _isSelected;

  @override
  void initState() {
    _isSelected = widget.provider.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s8.rw,
          ),
          child: Row(
            children: [
              SizedBox(
                height: AppSize.s36.rh,
                width: AppSize.s36.rw,
                child: Image.network(
                  '${envVariables.cdnUrl}${widget.provider.logo}',
                ),
              ),
              SizedBox(width: AppSize.s16.rw),
              Text(
                widget.provider.title,
                style: getRegularTextStyle(
                  color: AppColors.blueViolet,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              const Spacer(),
              Switch(
                onChanged: (isSelected) {
                  setState(() {
                    _isSelected = isSelected;
                    widget.onChange(_isSelected!, widget.provider);
                  });
                },
                value: _isSelected!,
                activeColor: AppColors.purpleBlue,
                activeTrackColor: AppColors.smokeyGrey,
                inactiveThumbColor: AppColors.black,
                inactiveTrackColor: AppColors.smokeyGrey,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
