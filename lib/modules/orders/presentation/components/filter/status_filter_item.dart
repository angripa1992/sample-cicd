import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/components/filter/status_filter.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class StatusFilterItem extends StatefulWidget {
  final StatusItem statusItem;
  final Function(bool, StatusItem) onCheckedChanged;

  const StatusFilterItem(
      {Key? key, required this.statusItem, required this.onCheckedChanged})
      : super(key: key);

  @override
  State<StatusFilterItem> createState() => _StatusFilterItemState();
}

class _StatusFilterItemState extends State<StatusFilterItem> {
  late bool _isChecked;

  @override
  void initState() {
    _isChecked = widget.statusItem.isChecked;
    super.initState();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.purpleBlue;
    }
    return AppColors.purpleBlue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: AppSize.s8.rw),
            child: Text(
              widget.statusItem.name,
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ),
          Checkbox(
            checkColor: AppColors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
                widget.onCheckedChanged(_isChecked, widget.statusItem);
              });
            },
          ),
        ],
      ),
    );
  }
}
