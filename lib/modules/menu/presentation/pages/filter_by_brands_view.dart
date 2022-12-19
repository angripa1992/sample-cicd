import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../domain/entities/brand.dart';

class FilterByBrandsView extends StatefulWidget {
  final List<MenuBrand> brands;
  final Function(MenuBrand) onChanged;

  const FilterByBrandsView(
      {Key? key, required this.brands, required this.onChanged})
      : super(key: key);

  @override
  State<FilterByBrandsView> createState() => _FilterByBrandsViewState();
}

class _FilterByBrandsViewState extends State<FilterByBrandsView> {
  MenuBrand? dropDownValue;
  late GlobalKey _dropdownKey;
  @override
  void initState() {
    _dropdownKey = GlobalKey();
    super.initState();
  }

  final dropDownTextStyle = getRegularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSize.s4.rw, bottom: AppSize.s10.rh),
          child: Text(
            'Filter by brand',
            style: getRegularTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            color: AppColors.lightVioletTwo,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
            child: DropdownButton<MenuBrand>(
              key: _dropdownKey,
              value: dropDownValue,
              isExpanded: true,
              underline: const SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.purpleBlue,
              ),
              hint: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Brand',
                  style: dropDownTextStyle,
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return widget.brands.map<Widget>((MenuBrand item) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.title,
                      style: dropDownTextStyle,
                    ),
                  );
                }).toList();
              },
              items: widget.brands.map<DropdownMenuItem<MenuBrand>>(
                (menu) {
                  return DropdownMenuItem<MenuBrand>(
                    value: menu,
                    child: RadioListTile<MenuBrand>(
                      title: Text(menu.title,style: dropDownTextStyle),
                      value: menu,
                      groupValue: dropDownValue,
                      activeColor: AppColors.purpleBlue,
                      onChanged: (value) {
                        Navigator.pop(_dropdownKey.currentContext!);
                        setState(() {
                          setState(() {
                            dropDownValue = value;
                            widget.onChanged(value!);
                          });
                        });
                      },
                    ),
                  );
                },
              ).toList(),
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }
}
