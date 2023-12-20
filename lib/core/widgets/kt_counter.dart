import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class KTCounter extends StatefulWidget {
  final bool enabled;
  final int count;
  final int minCount;
  final int? maxCount;
  final bool deletable;
  final Function(int) onChanged;

  const KTCounter({
    Key? key,
    required this.enabled,
    required this.count,
    required this.minCount,
    this.maxCount,
    this.deletable = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<KTCounter> createState() => _KTCounterState();
}

class _KTCounterState extends State<KTCounter> {
  late int _count;
  late int _maxCount;

  @override
  void initState() {
    _count = widget.count;
    _maxCount = widget.maxCount ?? 100;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant KTCounter oldWidget) {
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

  bool _reducible() {
    return (widget.enabled && widget.minCount != _count);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s200.rSp),
        border: Border.all(
          color: widget.enabled ? AppColors.black : AppColors.greyDarker,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s4.rw,
        ),
        child: Row(
          children: [
            IconButton(
              constraints: const BoxConstraints(),
              onPressed: _reducible() ? _decrement : null,
              icon: (widget.deletable && widget.minCount == _count - 1)
                  ? ImageResourceResolver.deleteSVG.getImageWidget(
                      width: AppSize.s14.rw,
                      height: AppSize.s14.rh,
                      color: _reducible() ? AppColors.errorR300 : AppColors.errorR300.withOpacity(0.5),
                    )
                  : Icon(
                      Icons.remove,
                      size: AppSize.s14.rSp,
                      color: _reducible() ? AppColors.black : AppColors.greyDarker,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
              child: Text(
                _count.toString(),
                style: semiBoldTextStyle(
                  color: widget.enabled ? AppColors.black : AppColors.greyDarker,
                  fontSize: AppFontSize.s12.rSp,
                ),
              ),
            ),
            IconButton(
              constraints: const BoxConstraints(),
              enableFeedback: false,
              onPressed: widget.enabled ? _increment : null,
              icon: Icon(
                Icons.add,
                size: AppSize.s14.rSp,
                color: widget.enabled ? AppColors.black : AppColors.greyDarker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
