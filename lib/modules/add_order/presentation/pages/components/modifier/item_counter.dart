import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class ItemCounter extends StatefulWidget {
  final int count;
  final Function(int) onChanged;

  const ItemCounter({Key? key, required this.count, required this.onChanged})
      : super(key: key);

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
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _decrement,
              icon: Icon(
                Icons.remove,
                color: AppColors.black,
              ),
            ),
            VerticalDivider(
              color: AppColors.black,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
              child: Text(
                count.toString(),
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
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              enableFeedback: false,
              onPressed: _increment,
              icon: Icon(
                Icons.add,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
