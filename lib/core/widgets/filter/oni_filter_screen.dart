import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/filter/multiple_branch_filter.dart';
import 'package:klikit/core/widgets/filter/multiple_status_filter.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';

import '../../../resources/styles.dart';
import '../kt_checkbox_group.dart';
import 'date_filter.dart';
import 'filter_data.dart';
import 'multiple_brand_filter.dart';
import 'multiple_provider_filter.dart';

class OniFilterScreen extends StatefulWidget {
  final OniFilteredData? initData;
  final bool isHistory;
  final Function(OniFilteredData?) onApplyFilterCallback;

  const OniFilterScreen({
    super.key,
    required this.onApplyFilterCallback,
    required this.isHistory,
    this.initData,
  });

  @override
  State<OniFilterScreen> createState() => _OniFilterScreenState();
}

class _OniFilterScreenState extends State<OniFilterScreen> {
  final List<KTCheckboxValue> _selectedBranches = [];
  final List<KTCheckboxValue> _selectedBrands = [];
  final List<KTCheckboxValue> _selectedProviders = [];
  final List<KTCheckboxValue> _selectedStatues = [];
  DateFilteredData? _dateFilteredData;

  @override
  void initState() {
    if (widget.initData != null) {
      _selectedBranches.addAll(widget.initData?.branches ?? []);
      _selectedBrands.addAll(widget.initData?.brands ?? []);
      _selectedProviders.addAll(widget.initData?.providers ?? []);
      _selectedStatues.addAll(widget.initData?.statuses ?? []);
      _dateFilteredData = widget.initData?.dateFilteredData;
    }
    super.initState();
  }

  void _applyFilter() {
    final brands = _selectedBrands.where((element) => element.isSelected ?? false).toList();
    final branches = _selectedBranches.where((element) => element.isSelected ?? false).toList();
    final providers = _selectedProviders.where((element) => element.isSelected ?? false).toList();
    final statues = _selectedStatues.where((element) => element.isSelected ?? false).toList();
    OniFilteredData? appliedFilter;
    if (providers.isEmpty && brands.isEmpty && branches.isEmpty && statues.isEmpty && _dateFilteredData == null) {
      appliedFilter = null;
    } else {
      appliedFilter = OniFilteredData(
        branches: branches,
        brands: brands,
        dateFilteredData: _dateFilteredData,
        providers: providers,
        statuses: statues,
      );
    }
    widget.onApplyFilterCallback(appliedFilter);
    Navigator.pop(context);
  }

  void _clearAll() {
    _dateFilteredData = null;
    _selectedBranches.clear();
    _selectedBrands.clear();
    _selectedProviders.clear();
    _selectedStatues.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: Text(
              'Clear all',
              style: semiBoldTextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.isHistory)
                    DateFilter(
                      initialData: _dateFilteredData,
                      onChangedCallback: (dateFilteredData) {
                        _dateFilteredData = dateFilteredData;
                      },
                    ),
                  if (widget.isHistory) Divider(color: AppColors.grey, thickness: 8.rh),
                  if (UserPermissionManager().isBizOwner())
                    MultipleBranchFilter(
                      initialSelectedValues: _selectedBranches,
                      onChangedCallback: (selectedBranches) {
                        _selectedBranches.clear();
                        _selectedBranches.addAll(selectedBranches);
                      },
                    ),
                  if (UserPermissionManager().isBizOwner()) Divider(color: AppColors.grey, thickness: 8.rh),
                  MultipleBrandFilter(
                    initialSelectedValues: _selectedBrands,
                    onChangedCallback: (values) {
                      _selectedBrands.clear();
                      _selectedBrands.addAll(values);
                    },
                  ),
                  Divider(color: AppColors.grey, thickness: 8.rh),
                  MultipleProviderFilter(
                    initialSelectedValues: _selectedProviders,
                    onChangedCallback: (values) {
                      _selectedProviders.clear();
                      _selectedProviders.addAll(values);
                    },
                  ),
                  if (widget.isHistory) Divider(color: AppColors.grey, thickness: 8.rh),
                  if (widget.isHistory)
                    MultipleStatusFilter(
                      initialSelectedValues: _selectedStatues,
                      onChangedCallback: (values) {
                        _selectedStatues.clear();
                        _selectedStatues.addAll(values);
                      },
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
            child: KTButton(
              controller: KTButtonController(label: 'Apply Filter', enabled: true),
              backgroundDecoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.rSp),
              ),
              labelStyle: mediumTextStyle(color: AppColors.white, fontSize: 14.rSp),
              onTap: _applyFilter,
            ),
          ),
        ],
      ),
    );
  }
}
