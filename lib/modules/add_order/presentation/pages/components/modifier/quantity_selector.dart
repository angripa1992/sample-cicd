import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.rSp),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _decrement,
            icon: Icon(Icons.remove, color: AppColors.black),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.rw),
            child: Text(
              '$_quantity',
              style: mediumTextStyle(color: AppColors.black, fontSize: 16.rSp),
            ),
          ),
          IconButton(
            onPressed: _increment,
            icon: Icon(Icons.add, color: AppColors.black),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
