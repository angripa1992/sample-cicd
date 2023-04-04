import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;
  @override
  void initState() {
    _quantity = widget.quantity;
    super.initState();
  }

  void _increment(){
    setState(() {
      _quantity += 1;
    });
    widget.onQuantityChanged(_quantity);
  }

  void _decrement(){
    if(_quantity > 1){
      setState(() {
        _quantity -= 1;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _decrement,
          icon: Icon(
            Icons.remove_circle,
            color: AppColors.purpleBlue,
          ),
        ),
        Text(
          '$_quantity',
          style: getMediumTextStyle(
            color: AppColors.balticSea,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        IconButton(
          onPressed: _increment,
          icon: Icon(
            Icons.add_circle,
            color: AppColors.purpleBlue,
          ),
        ),
      ],
    );
  }
}
