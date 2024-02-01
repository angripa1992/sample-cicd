import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/resources/strings.dart';

import '../../resources/colors.dart';
import '../../resources/styles.dart';

class KTCheckboxValue {
  final int id;
  final String title;
  final String? logo;
  bool? isSelected;

  KTCheckboxValue(this.id,
      this.title, {
        this.logo,
        this.isSelected = false,
      });

  @override
  String toString() {
    return 'id = $id, title = $title, logo = $logo, isSelected = $isSelected';
  }
}

class KTCheckboxGroup extends StatefulWidget {
  final List<KTCheckboxValue> values;
  final Function(List<KTCheckboxValue>) onChangedCallback;

  const KTCheckboxGroup({super.key, required this.values, required this.onChangedCallback});

  @override
  State<KTCheckboxGroup> createState() => _KTCheckboxGroupState();
}

class _KTCheckboxGroupState extends State<KTCheckboxGroup> {
  final _selectAllItemID = -1;
  final List<KTCheckboxValue> _modifiedValues = [];

  @override
  void initState() {
    _initValues();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant KTCheckboxGroup oldWidget) {
    _initValues();
    super.didUpdateWidget(oldWidget);
  }

  void _initValues() {
    final totalItems = widget.values.length;
    final numberOfSelectedItems = widget.values.where((element) => element.isSelected ?? false).length;
    final isAllSelected = (numberOfSelectedItems > 0) && (totalItems == numberOfSelectedItems);
    _modifiedValues.clear();
    _modifiedValues.add(KTCheckboxValue(_selectAllItemID, AppStrings.select_all.tr(), isSelected: isAllSelected));
    _modifiedValues.addAll(widget.values);
  }

  bool _allSelected() {
    final totalItems = widget.values.length;
    final numberOfSelectedItems = _modifiedValues.where((element) {
      if (element.id == _selectAllItemID || element.isSelected == null) {
        return false;
      } else {
        return element.isSelected!;
      }
    }).length;
    return totalItems == numberOfSelectedItems;
  }

  bool _allDeselected() {
    final totalItems = widget.values.length;
    final numberOfDeselectedItems = _modifiedValues.where((element) {
      if (element.id == _selectAllItemID || element.isSelected == null) {
        return false;
      } else {
        return !element.isSelected!;
      }
    }).length;
    return totalItems == numberOfDeselectedItems;
  }

  void _updateAllCheckbox(bool selected) {
    final item = _modifiedValues.firstWhere((element) => element.id == _selectAllItemID);
    item.isSelected = selected;
  }

  void _onChanged(KTCheckboxValue value, bool isSelected) {
    if (value.id == _selectAllItemID) {
      for (var modifiedValue in _modifiedValues) {
        modifiedValue.isSelected = isSelected;
      }
    } else {
      value.isSelected = isSelected;
      if (_allSelected()) {
        _updateAllCheckbox(true);
      } else {
        _updateAllCheckbox(false);
      }
    }
    _removeSelectAllItemAndSendCallback();
    setState(() {});
  }

  void _removeSelectAllItemAndSendCallback() {
    final values = <KTCheckboxValue>[];
    values.addAll(_modifiedValues);
    values.removeWhere((element) => element.id == _selectAllItemID);
    widget.onChangedCallback(values);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _modifiedValues.map((value) {
        return value.logo != null
            ? CheckboxListTile(
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          title: _title(value),
          value: value.isSelected,
          secondary: SizedBox(
            width: 32.rSp,
            height: 32.rSp,
            child: KTNetworkImage(
              imageUrl: value.logo!,
              width: 32.rSp,
              height: 32.rSp,
            ),
          ),
          onChanged: (isSelected) {
            _onChanged(value, isSelected!);
          },
        )
            : CheckboxListTile(
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                title: _title(value),
                value: value.isSelected,
                onChanged: (isSelected) {
                  _onChanged(value, isSelected!);
                },
              );
      }).toList(),
    );
  }

  Widget _title(KTCheckboxValue value) {
    return Text(
      value.title,
      style: mediumTextStyle(
        color: AppColors.neutralB500,
        fontSize: 14.rSp,
      ),
    );
  }
}
