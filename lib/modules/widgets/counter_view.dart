import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class CounterView extends StatefulWidget {
  final bool enabled;
  final int count;
  final int minCount;
  final int? maxCount;
  final Function(int) onChanged;

  const CounterView({
    Key? key,
    required this.enabled,
    required this.count,
    required this.onChanged,
    required this.minCount,
    this.maxCount,
  }) : super(key: key);

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late int _count;
  late int _maxCount;

  @override
  void initState() {
    _count = widget.count;
    _maxCount = widget.maxCount ?? 100;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CounterView oldWidget) {
    setState(() {
      _count = widget.count;
      _maxCount = widget.maxCount ?? 100;
    });
    super.didUpdateWidget(oldWidget);
  }

  void _increment() {
    if (widget.enabled && _count < (_maxCount)) {
      setState(() {
        _count += 1;
      });
      widget.onChanged(_count);
    }
  }

  void _decrement() {
    if (widget.enabled && _count > widget.minCount) {
      setState(() {
        _count -= 1;
      });
      widget.onChanged(_count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        border: Border.all(
          color: widget.enabled ? AppColors.black : AppColors.greyDarker,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s4.rw,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _decrement,
                icon: Icon(
                  Icons.remove,
                  color: widget.enabled ? AppColors.black : AppColors.greyDarker,
                ),
              ),
              VerticalDivider(
                color: widget.enabled ? AppColors.black : AppColors.greyDarker,
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
                child: Text(
                  _count.toString(),
                  style: mediumTextStyle(
                    color: widget.enabled ? AppColors.black : AppColors.greyDarker,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
              VerticalDivider(
                color: widget.enabled ? AppColors.black : AppColors.greyDarker,
                thickness: 1,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                enableFeedback: false,
                onPressed: _increment,
                icon: Icon(
                  Icons.add,
                  color: widget.enabled ? AppColors.black : AppColors.greyDarker,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
