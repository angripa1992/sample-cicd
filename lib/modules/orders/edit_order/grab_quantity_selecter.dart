import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class GrabQuantitySelector extends StatefulWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const GrabQuantitySelector({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<GrabQuantitySelector> createState() => _GrabQuantitySelectorState();
}

class _GrabQuantitySelectorState extends State<GrabQuantitySelector> {
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
    if (_quantity >= 1) {
      setState(() {
        _quantity -= 1;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  void didUpdateWidget(covariant GrabQuantitySelector oldWidget) {
    setState(() {
      _quantity = widget.quantity;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _decrement,
          icon: Icon(
            Icons.remove_circle,
            color: AppColors.primary,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
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
        IconButton(
          onPressed: _increment,
          icon: Icon(
            Icons.add_circle,
            color: AppColors.primary,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
