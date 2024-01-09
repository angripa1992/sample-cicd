import 'package:flutter/material.dart';

import '../kt_checkbox_group.dart';
import '../kt_radio_group.dart';

class HomeFilteredData {
  final DateFilteredData? dateFilteredData;
  final List<KTCheckboxValue>? branches;
  final List<KTCheckboxValue>? brands;

  HomeFilteredData({
    required this.dateFilteredData,
    required this.branches,
    required this.brands,
  });
}

class MenuFilteredData {
  final KTRadioValue? brand;
  final KTRadioValue? branch;
  final List<KTCheckboxValue>? providers;

  MenuFilteredData({
    required this.brand,
    required this.branch,
    required this.providers,
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
