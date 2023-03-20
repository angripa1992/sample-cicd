import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/brand.dart';

class SelectBrandDropDown extends StatefulWidget {
  final List<MenuBrand> brands;
  final Function(MenuBrand) onChanged;

  const SelectBrandDropDown({
    Key? key,
    required this.brands,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectBrandDropDown> createState() => _SelectBrandDropDownState();
}

class _SelectBrandDropDownState extends State<SelectBrandDropDown> {
  MenuBrand? dropDownValue;
  final _textStyle = getMediumTextStyle(
    color: AppColors.balticSea,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  void initState() {
    super.initState();
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
        value: dropDownValue,
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
                  if (menu.id == dropDownValue?.id)
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
            dropDownValue = value;
            widget.onChanged(value!);
          });
        },
      ),
    );
  }
}
