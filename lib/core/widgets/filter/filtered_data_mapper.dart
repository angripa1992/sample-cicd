import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/common/business_information_provider.dart';

import '../../../app/constants.dart';
import '../../../resources/strings.dart';
import '../kt_checkbox_group.dart';
import '../kt_radio_group.dart';

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

  List<StatusItem> statusItems() {
    return [
      StatusItem(OrderStatus.DELIVERED, AppStrings.delivered.tr()),
      StatusItem(OrderStatus.PICKED_UP, AppStrings.picked_up.tr()),
      StatusItem(OrderStatus.CANCELLED, AppStrings.canceled.tr()),
    ];
  }

  Future<Map<String, dynamic>> homeFilterDataMap(HomeFilteredData? data) async {
    final branches = await extractBranchIDs(data?.branches);
    final brands = await extractBrandIDs(data?.brands);
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
        if (!data.dateTimeRange!.start.isSameDate(data.dateTimeRange!.end)) {
          endDate = formatter.format(data.dateTimeRange!.end);
        }
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

  Future<List<int>> extractBranchIDs(List<KTCheckboxValue>? values) async {
    if (!UserPermissionManager().isBizOwner()) {
      return [SessionManager().branchId()];
    }
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

  Future<List<int>> extractBrandIDs(List<KTCheckboxValue>? values) async {
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

  Future<List<int>> extractProviderIDs(List<KTCheckboxValue>? values) async {
    final providers = <int>[];
    if (values == null || values.isEmpty) {
      final response = await getIt.get<BusinessInformationProvider>().fetchProviders();
      final providerIDs = response.map((e) => e.id).toList();
      providers.addAll(providerIDs);
    } else {
      final providerIDs = values.map((e) => e.id).toList();
      providers.addAll(providerIDs);
    }
    return providers;
  }

  Future<List<int>> extractStatusIDs(List<KTCheckboxValue>? values) async {
    final status = <int>[];
    if (values == null || values.isEmpty) {
      final ids = statusItems().map((e) => e.id).toList();
      status.addAll(ids);
    } else {
      final ids = values.map((e) => e.id).toList();
      status.addAll(ids);
    }
    return status;
  }

  Future<OniFilteredData> initialOniFilteredData() async {
    final brands = await _brandsInitFilterData();
    final branches = await _branchesInitFilterData();
    final providers = await _providersInitFilterData();
    final statues = await _statuesInitFilterData();
    final date = _dateInitData();
    return OniFilteredData(
      dateFilteredData: date,
      branches: branches,
      brands: brands,
      providers: providers,
      statuses: statues,
    );
  }

  Future<List<KTCheckboxValue>> _brandsInitFilterData() async {
    final brands = <KTCheckboxValue>[];
    final response = await getIt.get<BusinessInformationProvider>().fetchBrands();
    for (var element in response) {
      brands.add(KTCheckboxValue(element.id, element.title, logo: element.logo, isSelected: true));
    }
    return brands;
  }

  Future<List<KTCheckboxValue>> _branchesInitFilterData() async {
    final branches = <KTCheckboxValue>[];
    final response = await getIt.get<BusinessInformationProvider>().fetchBranches();
    for (var element in response) {
      branches.add(KTCheckboxValue(element.id, element.title, isSelected: true));
    }
    return branches;
  }

  Future<List<KTCheckboxValue>> _providersInitFilterData() async {
    final providers = <KTCheckboxValue>[];
    final response = await getIt.get<BusinessInformationProvider>().fetchProviders();
    for (var element in response) {
      providers.add(KTCheckboxValue(element.id, element.title, logo: element.logo, isSelected: true));
    }
    return providers;
  }

  Future<List<KTCheckboxValue>> _statuesInitFilterData() async {
    final providers = <KTCheckboxValue>[];
    for (var element in statusItems()) {
      providers.add(KTCheckboxValue(element.id, element.name, isSelected: true));
    }
    return providers;
  }

  DateFilteredData _dateInitData() {
    return DateFilteredData(
      selectedItem: KTRadioValue(DateType.today, 'Today', subTitle: '( Default )'),
      dateTimeRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    );
  }
}
