import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/branch.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/colors.dart';

import '../../../resources/styles.dart';
import '../kt_checkbox_group.dart';
import '../kt_radio_group.dart';
import 'custom_expansion_tile.dart';
import 'date_filter.dart';

class AppliedFilterData {
  final KTRadioValue? dateType;
  final KTRadioValue? branch;
  final List<KTCheckboxValue>? branches;
  final List<KTCheckboxValue>? brands;

  AppliedFilterData({
    required this.dateType,
    required this.branch,
    required this.branches,
    required this.brands,
  });
}

class FilterScreen extends StatefulWidget {
  final AppliedFilterData? initialFilteredData;
  final Function(AppliedFilterData) onApplyFilterCallback;

  const FilterScreen({
    super.key,
    required this.onApplyFilterCallback,
    this.initialFilteredData,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<KTCheckboxValue> _selectedBranches = [];
  final List<KTCheckboxValue> _selectedBrands = [];
  KTRadioValue? _selectedDateType;
  KTRadioValue? _selectedBranch;

  @override
  void initState() {
    if (widget.initialFilteredData != null) {
      _selectedBranches.addAll(widget.initialFilteredData?.branches ?? []);
      _selectedBrands.addAll(widget.initialFilteredData?.brands ?? []);
    }
    super.initState();
  }

  List<KTCheckboxValue> _brandFilterItem(List<Brand> brands) {
    return brands.map((brand) {
      final alreadySelectedOrNull = _selectedBrands.firstWhereOrNull((element) => element.id == brand.id);
      return KTCheckboxValue(
        brand.id,
        brand.title,
        logo: brand.logo,
        isSelected: alreadySelectedOrNull?.isSelected ?? false,
      );
    }).toList();
  }

  List<KTCheckboxValue> _branchFilterItem(List<Branch> branches) {
    return branches.map((branch) {
      final alreadySelectedOrNull = _selectedBranches.firstWhereOrNull((element) => element.id == branch.id);
      return KTCheckboxValue(
        branch.id,
        branch.title,
        isSelected: alreadySelectedOrNull?.isSelected ?? false,
      );
    }).toList();
  }

  void _applyFilter() {
    final brands = _selectedBrands.where((element) => element.isSelected ?? false).toList();
    final branches = _selectedBranches.where((element) => element.isSelected ?? false).toList();
    final appliedFilter = AppliedFilterData(
      dateType: _selectedDateType,
      branch: _selectedBranch,
      branches: branches,
      brands: brands,
    );
    widget.onApplyFilterCallback(appliedFilter);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        actions: [
          TextButton(
            onPressed: () {},
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
                  DateFilter(),
                  Divider(color: AppColors.grey, thickness: 8.rh),
                  CustomExpansionTile(
                    title: 'Branches',
                    trailingIcon: Icons.add,
                    expandedTrailingIcon: Icons.remove,
                    color: AppColors.black,
                    expandedColor: AppColors.black,
                    initiallyExpanded: true,
                    child: FutureBuilder<List<Branch>>(
                      future: getIt.get<BusinessInformationProvider>().getBranches(),
                      builder: (_, snap) {
                        if (snap.hasData && snap.data != null) {
                          return KTCheckboxGroup(
                            values: _branchFilterItem(snap.data!),
                            onChangedCallback: (modifiedValues) {
                              _selectedBranches.clear();
                              _selectedBranches.addAll(modifiedValues);
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ).setVisibilityWithSpace(
                          startSpace: 8,
                          endSpace: 8,
                          direction: Axis.vertical,
                        );
                      },
                    ),
                  ),
                  Divider(color: AppColors.grey, thickness: 8.rh),
                  CustomExpansionTile(
                    title: 'Brands',
                    trailingIcon: Icons.add,
                    expandedTrailingIcon: Icons.remove,
                    color: AppColors.black,
                    expandedColor: AppColors.black,
                    initiallyExpanded: true,
                    child: FutureBuilder<List<Brand>>(
                      future: getIt.get<BusinessInformationProvider>().fetchBrands(),
                      builder: (_, snap) {
                        if (snap.hasData && snap.data != null) {
                          return KTCheckboxGroup(
                            values: _brandFilterItem(snap.data!),
                            onChangedCallback: (modifiedValues) {
                              _selectedBrands.clear();
                              _selectedBrands.addAll(modifiedValues);
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ).setVisibilityWithSpace(
                          startSpace: 8,
                          endSpace: 8,
                          direction: Axis.vertical,
                        );
                      },
                    ),
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
