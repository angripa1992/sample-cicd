import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/filter/apply_filter_button.dart';
import 'package:klikit/core/widgets/filter/filter_app_bar.dart';
import 'package:klikit/core/widgets/filter/multiple_branch_filter.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../kt_checkbox_group.dart';
import 'date_filter.dart';
import 'filter_data.dart';
import 'multiple_brand_filter.dart';

class HomeFilterScreen extends StatefulWidget {
  final HomeFilteredData? initData;
  final Function(HomeFilteredData?) onApplyFilterCallback;

  const HomeFilterScreen({
    super.key,
    required this.onApplyFilterCallback,
    this.initData,
  });

  @override
  State<HomeFilterScreen> createState() => _HomeFilterScreenState();
}

class _HomeFilterScreenState extends State<HomeFilterScreen> {
  final List<KTCheckboxValue> _selectedBranches = [];
  final List<KTCheckboxValue> _selectedBrands = [];
  DateFilteredData? _dateFilteredData;

  @override
  void initState() {
    if (widget.initData != null) {
      _selectedBranches.addAll(widget.initData?.branches ?? []);
      _selectedBrands.addAll(widget.initData?.brands ?? []);
      _dateFilteredData = widget.initData?.dateFilteredData;
    }
    super.initState();
  }

  void _applyFilter() {
    final brands = _selectedBrands.where((element) => element.isSelected ?? false).toList();
    final branches = _selectedBranches.where((element) => element.isSelected ?? false).toList();
    HomeFilteredData? appliedFilter;
    if (brands.isEmpty && branches.isEmpty && _dateFilteredData == null) {
      appliedFilter = null;
    } else {
      appliedFilter = HomeFilteredData(branches: branches, brands: brands, dateFilteredData: _dateFilteredData);
    }
    widget.onApplyFilterCallback(appliedFilter);
    Navigator.pop(context);
  }

  void _clearAll() {
    _dateFilteredData = null;
    _selectedBranches.clear();
    _selectedBrands.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterAppBar(
        clearAll: _clearAll,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DateFilter(
                    initialData: _dateFilteredData,
                    onChangedCallback: (dateFilteredData) {
                      _dateFilteredData = dateFilteredData;
                    },
                  ),
                  AppSize.s8.verticalSpacer(),
                  if (UserPermissionManager().isBizOwner())
                    MultipleBranchFilter(
                      initialSelectedValues: _selectedBranches,
                      onChangedCallback: (selectedBranches) {
                        _selectedBranches.clear();
                        _selectedBranches.addAll(selectedBranches);
                      },
                    ),
                  if (UserPermissionManager().isBizOwner()) Divider(color: AppColors.neutralB30, thickness: 8.rh),
                  MultipleBrandFilter(
                    initialSelectedValues: _selectedBrands,
                    onChangedCallback: (selectedBrands) {
                      _selectedBrands.clear();
                      _selectedBrands.addAll(selectedBrands);
                    },
                  ),
                ],
              ),
            ),
          ),
          ApplyFilterButton(applyFilter: _applyFilter),
        ],
      ),
    );
  }
}
