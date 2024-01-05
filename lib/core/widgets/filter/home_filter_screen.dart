import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/filter/multiple_branch_filter.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';

import '../../../resources/styles.dart';
import '../kt_checkbox_group.dart';
import 'date_filter.dart';
import 'filter_data.dart';
import 'multiple_brand_filter.dart';

class HomeFilterScreen extends StatefulWidget {
  final HomeFilterAppliedData? initialFilteredData;
  final Function(HomeFilterAppliedData?) onApplyFilterCallback;

  const HomeFilterScreen({
    super.key,
    required this.onApplyFilterCallback,
    this.initialFilteredData,
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
    if (widget.initialFilteredData != null) {
      _selectedBranches.addAll(widget.initialFilteredData?.branches ?? []);
      _selectedBrands.addAll(widget.initialFilteredData?.brands ?? []);
      _dateFilteredData = widget.initialFilteredData?.dateFilteredData;
    }
    super.initState();
  }

  void _applyFilter() {
    final brands = _selectedBrands.where((element) => element.isSelected ?? false).toList();
    final branches = _selectedBranches.where((element) => element.isSelected ?? false).toList();
    HomeFilterAppliedData? appliedFilter;
    if (brands.isEmpty && branches.isEmpty && _dateFilteredData == null) {
      appliedFilter = null;
    } else {
      appliedFilter = HomeFilterAppliedData(branches: branches, brands: brands, dateFilteredData: _dateFilteredData);
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
                  DateFilter(
                    initialData: _dateFilteredData,
                    onChangedCallback: (dateFilteredData) {
                      _dateFilteredData = dateFilteredData;
                    },
                  ),
                  Divider(color: AppColors.grey, thickness: 8.rh),
                  MultipleBranchFilter(
                    initialSelectedValues: _selectedBranches,
                    onChangedCallback: (selectedBranches) {
                      _selectedBranches.clear();
                      _selectedBranches.addAll(selectedBranches);
                    },
                  ),
                  Divider(color: AppColors.grey, thickness: 8.rh),
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
