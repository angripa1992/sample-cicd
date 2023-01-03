import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../../resources/values.dart';

class BrandFilterItem extends StatefulWidget {
  final Brand brand;
  final Function(bool, Brand) onChanged;

  const BrandFilterItem(
      {Key? key, required this.brand, required this.onChanged})
      : super(key: key);

  @override
  State<BrandFilterItem> createState() => _BrandFilterItemState();
}

class _BrandFilterItemState extends State<BrandFilterItem> {
  bool? _isChecked;

  @override
  void initState() {
    _isChecked = widget.brand.isChecked;
    super.initState();
  }

 @override
  void didUpdateWidget(covariant BrandFilterItem oldWidget) {
   _isChecked = widget.brand.isChecked;
    super.didUpdateWidget(oldWidget);
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: AppSize.s8.rw),
            child: Text(
              widget.brand.title,
              style: getRegularTextStyle(
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
                widget.onChanged(_isChecked!, widget.brand);
              });
            },
          ),
        ],
      ),
    );
  }
}
