import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

class ItemCounter extends StatefulWidget {
  final int count;
  final Function(int) onChanged;

  const ItemCounter({Key? key, required this.count, required this.onChanged}) : super(key: key);

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  late int count;

  @override
  void initState() {
    if (widget.count > 1) {
      count = widget.count;
    } else {
      count = 1;
    }
    widget.onChanged(count);
    super.initState();
  }

  void _increment() {
    setState(() {
      count += 1;
      widget.onChanged(count);
    });
  }

  void _decrement() {
    setState(() {
      if (count > 1) {
        count -= 1;
        widget.onChanged(count);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 4.rh),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.rSp),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _decrement,
            icon: Icon(Icons.remove, color: AppColors.black),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.rw),
            child: Text(
              count.toString(),
              style: mediumTextStyle(color: AppColors.black, fontSize: 16.rSp),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            enableFeedback: false,
            onPressed: _increment,
            icon: Icon(Icons.add, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
