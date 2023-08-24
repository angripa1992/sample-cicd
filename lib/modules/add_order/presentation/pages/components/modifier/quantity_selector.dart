import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

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

  void _increment() {
    setState(() {
      _quantity += 1;
    });
    widget.onQuantityChanged(_quantity);
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity -= 1;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        border: Border.all(
          color: AppColors.black,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            IconButton(
              onPressed: _decrement,
              icon: Icon(
                Icons.remove,
                color: AppColors.black,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            VerticalDivider(
              color: AppColors.black,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
              child: Text(
                '$_quantity',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ),
            VerticalDivider(
              color: AppColors.black,
              thickness: 1,
            ),
            IconButton(
              onPressed: _increment,
              icon: Icon(
                Icons.add,
                color: AppColors.black,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
