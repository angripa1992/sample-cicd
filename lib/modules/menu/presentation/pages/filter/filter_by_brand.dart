import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class FilterByBrandsView extends StatefulWidget {
  final List<Brand> brands;
  final Function(Brand) onChanged;

  const FilterByBrandsView({Key? key, required this.brands, required this.onChanged}) : super(key: key);

  @override
  State<FilterByBrandsView> createState() => _FilterByBrandsViewState();
}

class _FilterByBrandsViewState extends State<FilterByBrandsView> {
  Brand? dropDownValue;
  final dropDownTextStyle = regularTextStyle(color: AppColors.neutralB700, fontSize: 14.rSp);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: AppSize.s4.rw, bottom: AppSize.s10.rh),
            child: Text(
              AppStrings.filter_by_brand.tr(),
              style: mediumTextStyle(
                color: AppColors.neutralB700,
                fontSize: 14.rSp,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                border: Border.all(color: AppColors.neutralB40)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
              child: DropdownButton<Brand>(
                value: dropDownValue,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.black,
                ),
                hint: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.select_brand.tr(),
                    style: dropDownTextStyle,
                  ),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return widget.brands.map<Widget>((Brand item) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.title,
                        style: dropDownTextStyle,
                      ),
                    );
                  }).toList();
                },
                items: widget.brands.map<DropdownMenuItem<Brand>>(
                  (menu) {
                    return DropdownMenuItem<Brand>(
                      value: menu,
                      child: Row(
                        children: [
                          Radio(
                            value: menu,
                            groupValue: dropDownValue,
                            onChanged: (value) {},
                            activeColor: AppColors.primary,
                          ),
                          Text(
                            menu.title,
                            style: dropDownTextStyle,
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
            ),
          ),
        ],
      ),
    );
  }
}
