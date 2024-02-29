import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/entities/branch.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class FilterByBranchView extends StatefulWidget {
  final List<Branch> branches;
  final Function(Branch) onChanged;

  const FilterByBranchView({Key? key, required this.branches, required this.onChanged}) : super(key: key);

  @override
  State<FilterByBranchView> createState() => _FilterByBranchViewState();
}

class _FilterByBranchViewState extends State<FilterByBranchView> {
  Branch? dropDownValue;
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
              'Filter by Branch',
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
              child: DropdownButton<Branch>(
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
                    'Select Branch',
                    style: dropDownTextStyle,
                  ),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return widget.branches.map<Widget>((Branch item) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.title,
                        style: dropDownTextStyle,
                      ),
                    );
                  }).toList();
                },
                items: widget.branches.map<DropdownMenuItem<Branch>>(
                  (menu) {
                    return DropdownMenuItem<Branch>(
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
