import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../../resources/colors.dart';
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
  final _textStyle = getRegularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s14.rSp,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.purpleBlue),
        borderRadius: BorderRadius.circular(4)
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
                children: [
                  Text(menu.title, style: _textStyle),
                  if (menu.id == dropDownValue?.id) Icon(Icons.check),
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
