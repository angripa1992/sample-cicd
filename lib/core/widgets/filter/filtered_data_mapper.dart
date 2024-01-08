import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/common/business_information_provider.dart';

import '../kt_checkbox_group.dart';

class FilteredDataMapper {
  static final _instance = FilteredDataMapper._internal();

  factory FilteredDataMapper() => _instance;

  FilteredDataMapper._internal();

  final _orderSource = 'order_source';
  final _providerID = 'provider_id';
  final _branchID = 'branch_id';
  final _brandID = 'brand_id';
  final _periodStart = 'period_start';
  final _periodEnd = 'period_end';
  final _period = 'period';

  Future<Map<String, dynamic>> homeFilterDataMap(HomeFilterAppliedData? data) async {
    final branches = await _branches(data?.branches);
    final brands = await _brands(data?.brands);
    final period = _dateMap(data?.dateFilteredData);
    final map = <String, dynamic>{};
    map.addAll(period);
    map[_period] = 'daily';
    map[_brandID] = ListParam(brands, ListFormat.csv);
    map[_branchID] = ListParam(branches, ListFormat.csv);
    return map;
  }

  Map<String, dynamic> _dateMap(DateFilteredData? data) {
    String? startDate;
    String? endDate;
    final formatter = DateFormat('yyyy-MM-dd');
    if (data != null) {
      final dateType = data.selectedItem?.id;
      startDate = formatter.format(data.dateTimeRange!.start);
      if (dateType != DateType.today && dateType != DateType.yesterday) {
        endDate = formatter.format(data.dateTimeRange!.end);
      }
    } else {
      startDate = formatter.format(DateTime.now());
    }
    final map = <String, dynamic>{};
    map[_periodStart] = startDate;
    if (endDate != null) {
      map[_periodEnd] = endDate;
    }
    return map;
  }

  Future<List<int>> _branches(List<KTCheckboxValue>? values) async {
    final branches = <int>[];
    if (values == null || values.isEmpty) {
      final response = await getIt.get<BusinessInformationProvider>().fetchBranches();
      final branchIds = response.map((e) => e.id).toList();
      branches.addAll(branchIds);
    } else {
      final branchIds = values.map((e) => e.id).toList();
      branches.addAll(branchIds);
    }
    return branches;
  }

  Future<List<int>> _brands(List<KTCheckboxValue>? values) async {
    final brands = <int>[];
    if (values == null || values.isEmpty) {
      final response = await getIt.get<BusinessInformationProvider>().fetchBrands();
      final brandIDs = response.map((e) => e.id).toList();
      brands.addAll(brandIDs);
    } else {
      final brandIDs = values.map((e) => e.id).toList();
      brands.addAll(brandIDs);
    }
    return brands;
  }
}
