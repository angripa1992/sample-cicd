import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/brand.dart';

class SelectBrandDropDown extends StatefulWidget {
  final List<MenuBrand> brands;
  final MenuBrand? initialBrand;
  final Function(MenuBrand) onChanged;

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
  MenuBrand? _dropDownValue;
  final _textStyle = getMediumTextStyle(
    color: AppColors.balticSea,
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
      padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.purpleBlue, width: AppSize.s1.rSp),
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
      ),
      child: DropdownButton<MenuBrand>(
        value: _dropDownValue,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.black,
        ),
        hint: Center(
          child: Text('Select a brand name', style: _textStyle),
        ),
        selectedItemBuilder: (BuildContext context) {
          return widget.brands.map<Widget>((MenuBrand item) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                item.title,
                style: _textStyle,
              ),
            );
          }).toList();
        },
        items: widget.brands.map<DropdownMenuItem<MenuBrand>>(
              (menu) {
            return DropdownMenuItem<MenuBrand>(
              value: menu,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(menu.title, style: _textStyle),
                  if (menu.id == _dropDownValue?.id)
                    Icon(
                      Icons.check,
                      color: AppColors.purpleBlue,
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
