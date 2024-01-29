import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

class CartItemCounterView extends StatefulWidget {
  final int count;
  final int minCount;
  final int? maxCount;
  final Function(int) onChanged;

  const CartItemCounterView({
    Key? key,
    required this.count,
    required this.onChanged,
    required this.minCount,
    this.maxCount,
  }) : super(key: key);

  @override
  State<CartItemCounterView> createState() => _CartItemCounterViewState();
}

class _CartItemCounterViewState extends State<CartItemCounterView> {
  late int _count;
  late int _maxCount;

  @override
  void initState() {
    _count = widget.count;
    _maxCount = widget.maxCount ?? 100;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CartItemCounterView oldWidget) {
    setState(() {
      _count = widget.count;
      _maxCount = widget.maxCount ?? 100;
    });
    super.didUpdateWidget(oldWidget);
  }

  void _increment() {
    if (_count < (_maxCount)) {
      setState(() {
        _count += 1;
      });
      widget.onChanged(_count);
    }
  }

  void _decrement() {
    if (_count > widget.minCount) {
      setState(() {
        _count -= 1;
      });
      widget.onChanged(_count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: _decrement,
          icon: Container(
            decoration: BoxDecoration(color: AppColors.neutralB100, borderRadius: BorderRadius.circular(16.rSp)),
            child: Icon(
              Icons.remove,
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rw),
          child: Text(
            _count.toString(),
            style: mediumTextStyle(
              color: AppColors.neutralB700,
              fontSize: 14.rSp,
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          enableFeedback: false,
          onPressed: _increment,
          icon: Container(
            decoration: BoxDecoration(
              color: AppColors.neutralB100,
              borderRadius: BorderRadius.circular(16.rSp),
            ),
            child: Icon(
              Icons.add,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
