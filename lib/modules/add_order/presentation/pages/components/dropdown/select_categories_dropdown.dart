import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/menu/menu_categories.dart';
import '../../../../utils/color_provider.dart';

class CategoriesDropDown extends StatefulWidget {
  final List<MenuCategory> categories;
  final Function(int) onChanged;
  final MenuCategory? initValue;

  const CategoriesDropDown({
    Key? key,
    required this.categories,
    required this.onChanged,
    required this.initValue,
  }) : super(key: key);

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  MenuCategory? _dropDownValue;
  final _textStyle = mediumTextStyle(
    color: AppColors.balticSea,
    fontSize: AppFontSize.s15.rSp,
  );

  int _getIndex(MenuCategory category) {
    return widget.categories.indexOf(category);
  }

  @override
  void initState() {
    _dropDownValue = widget.initValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CategoriesDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dropDownValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MenuCategory>(
      value: _dropDownValue,
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.black,
      ),
      hint: Center(
        child: Text(AppStrings.categories.tr(), style: _textStyle),
      ),
      selectedItemBuilder: (BuildContext context) {
        return widget.categories.map<Widget>((MenuCategory category) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.categories.tr(),
              style: _textStyle,
            ),
          );
        }).toList();
      },
      items: widget.categories.map<DropdownMenuItem<MenuCategory>>(
        (category) {
          return DropdownMenuItem<MenuCategory>(
            value: category,
            child: Container(
              margin: EdgeInsets.only(bottom: AppSize.s4.rh),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: CategoriesColorProvider().color(_getIndex(category)),
              ),
              alignment: Alignment.center,
              constraints: BoxConstraints(minHeight: AppSize.s42.rh),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                child: Row(
                  children: [
                    Expanded(child: Text(category.title, style: _textStyle)),
                    if (_dropDownValue?.id == category.id)
                      const Icon(Icons.check),
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(() {
          _dropDownValue = value;
          widget.onChanged(_getIndex(value!));
        });
      },
    );
  }
}
