import 'package:flutter/material.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';

import '../../../../../resources/colors.dart';

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
  bool? _isSelected;

  @override
  void initState() {
    _isSelected = widget.provider.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Image.network(widget.provider.logo,),
        Text(widget.provider.title),
        Switch(
          onChanged: (isSelected) {
            setState(() {
              _isSelected = isSelected;
              widget.onChange(_isSelected!,widget.provider);
            });
          },
          value: _isSelected!,
          activeColor: AppColors.purpleBlue,
          activeTrackColor: AppColors.smokeyGrey,
          inactiveThumbColor: AppColors.black,
          inactiveTrackColor: AppColors.smokeyGrey,
        ),
      ],
    );
  }
}
