import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/values.dart';

class SelectBrandDropDown extends StatefulWidget {
  final List<Brand> brands;
  final Brand? initialBrand;
  final Function(Brand) onChanged;

  const SelectBrandDropDown({
    Key? key,
    required this.brands,
    required this.onChanged,
    required this.initialBrand,
  }) : super(key: key);

  @override
  State<SelectBrandDropDown> createState() => _SelectBrandDropDownState();
}

class _SelectBrandDropDownState extends State<SelectBrandDropDown> {
  Brand? _dropDownValue;
  final _textStyle = mediumTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  void initState() {
    _dropDownValue = widget.initialBrand;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SelectBrandDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (((_dropDownValue != null && widget.initialBrand != null) && _dropDownValue!.id != widget.initialBrand!.id) || widget.initialBrand != null) {
      setState(() {
        _dropDownValue = widget.initialBrand;
        widget.onChanged(_dropDownValue!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: AppSize.s1.rSp),
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
      ),
      child: DropdownButton<Brand>(
        value: _dropDownValue,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.black,
        ),
        hint: Center(
          child: Text(AppStrings.select_brand_name.tr(), style: _textStyle),
        ),
        selectedItemBuilder: (BuildContext context) {
          return widget.brands.map<Widget>((Brand item) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                item.title,
                style: _textStyle,
              ),
            );
          }).toList();
        },
        items: widget.brands.map<DropdownMenuItem<Brand>>(
          (menu) {
            return DropdownMenuItem<Brand>(
              value: menu,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(menu.title, style: _textStyle),
                  if (menu.id == _dropDownValue?.id)
                    Icon(
                      Icons.check,
                      color: AppColors.primary,
                    ),
                ],
              ),
            );
          },
        ).toList(),
        onChanged: (value) {
          setState(() {
            _dropDownValue = value;
            widget.onChanged(value!);
          });
        },
      ),
    );
  }
}
