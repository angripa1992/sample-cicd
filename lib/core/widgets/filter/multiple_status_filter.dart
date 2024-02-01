import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/filter/filtered_data_mapper.dart';
import 'package:klikit/resources/strings.dart';

import '../../../resources/colors.dart';
import '../kt_checkbox_group.dart';
import 'custom_expansion_tile.dart';

class MultipleStatusFilter extends StatefulWidget {
  final List<KTCheckboxValue>? initialSelectedValues;
  final Function(List<KTCheckboxValue>) onChangedCallback;

  const MultipleStatusFilter({
    super.key,
    this.initialSelectedValues,
    required this.onChangedCallback,
  });

  @override
  State<MultipleStatusFilter> createState() => _MultipleStatusFilterState();
}

class _MultipleStatusFilterState extends State<MultipleStatusFilter> {
  final List<KTCheckboxValue> _selectedStatus = [];

  List<KTCheckboxValue> _statusFilterItems() {
    return FilteredDataMapper().statusItems().map((status) {
      final alreadySelectedOrNull = _selectedStatus.firstWhereOrNull((element) => element.id == status.id);
      return KTCheckboxValue(
        status.id,
        status.name,
        isSelected: alreadySelectedOrNull?.isSelected ?? false,
      );
    }).toList();
  }

  void _setInitValue() {
    _selectedStatus.clear();
    _selectedStatus.addAll(widget.initialSelectedValues ?? []);
  }

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MultipleStatusFilter oldWidget) {
    _setInitValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: AppStrings.status.tr(),
      trailingIcon: Icons.add,
      expandedTrailingIcon: Icons.remove,
      color: AppColors.black,
      expandedColor: AppColors.black,
      initiallyExpanded: true,
      child: KTCheckboxGroup(
        values: _statusFilterItems(),
        onChangedCallback: (modifiedValues) {
          _selectedStatus.clear();
          _selectedStatus.addAll(modifiedValues);
          widget.onChangedCallback(_selectedStatus);
        },
      ),
    );
  }
}
