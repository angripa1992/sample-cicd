import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/sub_section_list_item.dart';
import '../../../../utils/color_provider.dart';

class CategoriesDropDown extends StatefulWidget {
  final List<SubSectionListItem> items;
  final Function(int) onChanged;

  const CategoriesDropDown({
    Key? key,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  SubSectionListItem? _dropDownValue;
  final _textStyle = getMediumTextStyle(
    color: AppColors.balticSea,
    fontSize: AppFontSize.s15.rSp,
  );

  int _getIndex(SubSectionListItem item) {
    return widget.items.indexOf(item);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SubSectionListItem>(
      value: _dropDownValue,
      underline: const SizedBox(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.black,
      ),
      hint: Center(
        child: Text('Categories', style: _textStyle),
      ),
      selectedItemBuilder: (BuildContext context) {
        return widget.items.map<Widget>((SubSectionListItem item) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Categories',
              style: _textStyle,
            ),
          );
        }).toList();
      },
      items: widget.items.map<DropdownMenuItem<SubSectionListItem>>(
        (item) {
          return DropdownMenuItem<SubSectionListItem>(
            value: item,
            child: Container(
              color: CategoriesColorProvider().color(_getIndex(item)),
              alignment: Alignment.center,
              constraints: BoxConstraints(minHeight: AppSize.s42.rh),
              child: Text(item.subSections.title, style: _textStyle),
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