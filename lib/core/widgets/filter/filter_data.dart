import 'package:flutter/material.dart';

import '../kt_checkbox_group.dart';
import '../kt_radio_group.dart';

class HomeFilterAppliedDate {
  final DateFilteredData? dateFilteredData;
  final List<KTCheckboxValue>? branches;
  final List<KTCheckboxValue>? brands;

  HomeFilterAppliedDate({
    required this.dateFilteredData,
    required this.branches,
    required this.brands,
  });
}

class DateType {
  static const today = 1;
  static const yesterday = 2;
  static const lastWeek = 3;
  static const lastMonth = 4;
  static const custom = 5;
}

class DateFilteredData {
  final KTRadioValue? selectedItem;
  final DateTimeRange? dateTimeRange;

  DateFilteredData({this.selectedItem, this.dateTimeRange});
}
