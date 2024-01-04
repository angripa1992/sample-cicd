import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';

import '../../resources/colors.dart';
import '../../resources/styles.dart';

class KTCheckboxValue {
  final int id;
  final String title;
  final String? logo;
  bool? isSelected;

  KTCheckboxValue(
    this.id,
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
    _modifiedValues.add(KTCheckboxValue(_selectAllItemID, 'Select All', isSelected: isAllSelected));
    _modifiedValues.addAll(widget.values);
  }

  void _onChanged(KTCheckboxValue value, bool isSelected) {
    if (value.id == _selectAllItemID) {
      for (var modifiedValue in _modifiedValues) {
        modifiedValue.isSelected = isSelected;
      }
    } else {
      value.isSelected = isSelected;
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
        color: AppColors.black,
        fontSize: 14.rSp,
      ),
    );
  }
}
