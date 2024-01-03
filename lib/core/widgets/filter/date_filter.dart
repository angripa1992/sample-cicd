import 'package:flutter/material.dart';

import '../../../resources/colors.dart';
import '../../functions/pickers.dart';
import '../kt_radio_group.dart';
import 'custom_expansion_tile.dart';

class DateType {
  static const today = 1;
  static const yesterday = 2;
  static const lastWeek = 3;
  static const lastMonth = 4;
  static const custom = 5;
}

class AppliedDateFilterData {
  final KTRadioValue? selectedItem;
  final DateTimeRange? dateTimeRange;

  AppliedDateFilterData({this.selectedItem, this.dateTimeRange});
}

class DateFilter extends StatefulWidget {
  final AppliedDateFilterData? initialData;

  const DateFilter({super.key, this.initialData});

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  AppliedDateFilterData? _appliedDateFilterData;

  List<KTRadioValue> _filterItems() {
    final items = [
      KTRadioValue(DateType.today, 'Today', subTitle: '(Default)'),
      KTRadioValue(DateType.yesterday, 'Yesterday'),
      KTRadioValue(DateType.lastWeek, 'Last Week'),
      KTRadioValue(DateType.lastMonth, 'Last Month'),
    ];
    if (_appliedDateFilterData != null && _appliedDateFilterData?.selectedItem != null && _appliedDateFilterData!.selectedItem!.id == DateType.custom) {
      final customItem = KTRadioValue(
        DateType.custom,
        'Custom',
        subTitle: '${_appliedDateFilterData?.dateTimeRange?.start} - ${_appliedDateFilterData?.dateTimeRange?.end}',
        editableIcon: Icons.edit_calendar,
      );
      items.add(customItem);
    } else {
      items.add(KTRadioValue(DateType.custom, 'Custom'));
    }
    return items;
  }

  void _onSelected(KTRadioValue selectedValue) async {
    DateTimeRange? dateTimeRange;
    if (selectedValue.id == DateType.today) {
      dateTimeRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    } else if (selectedValue.id == DateType.yesterday) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      dateTimeRange = DateTimeRange(start: yesterday, end: yesterday);
    } else if (selectedValue.id == DateType.lastWeek) {
      final lastWeek = DateTime.now().subtract(const Duration(days: 6));
      dateTimeRange = DateTimeRange(start: lastWeek, end: DateTime.now());
    } else if (selectedValue.id == DateType.lastMonth) {
      final lastMonth = DateTime.now().subtract(const Duration(days: 29));
      dateTimeRange = DateTimeRange(start: lastMonth, end: DateTime.now());
    } else {
      dateTimeRange = await showKTDateRangePicker(context: context);
    }
    setState(() {
      _appliedDateFilterData = AppliedDateFilterData(
        selectedItem: selectedValue,
        dateTimeRange: dateTimeRange,
      );
    });
  }

  void _setInitialValue() {
    if (widget.initialData == null) {
      _appliedDateFilterData = AppliedDateFilterData(
        selectedItem: KTRadioValue(DateType.today, 'Today', subTitle: '(Default)'),
        dateTimeRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
      );
    } else {
      _appliedDateFilterData = widget.initialData;
    }
  }

  @override
  void initState() {
    _setInitialValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'Date',
      trailingIcon: Icons.add,
      expandedTrailingIcon: Icons.remove,
      color: AppColors.black,
      expandedColor: AppColors.black,
      initiallyExpanded: true,
      child: KTRadioGroup(
        initiallySelectedButtonID: _appliedDateFilterData?.selectedItem?.id,
        values: _filterItems(),
        onChangedCallback: _onSelected,
        onEditItemValue: _onSelected,
      ),
    );
  }
}
