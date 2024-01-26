import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/filter/multiple_provider_filter.dart';
import 'package:klikit/core/widgets/filter/single_branch_filter.dart';
import 'package:klikit/core/widgets/filter/single_brand_filter.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/kt_radio_group.dart';
import 'package:klikit/resources/colors.dart';

import '../../../resources/styles.dart';
import '../kt_checkbox_group.dart';
import 'filter_data.dart';

class MenuFilterScreen extends StatefulWidget {
  final MenuFilteredData? initData;
  final Function(MenuFilteredData?) onApplyFilterCallback;

  const MenuFilterScreen({
    super.key,
    required this.onApplyFilterCallback,
    this.initData,
  });

  @override
  State<MenuFilterScreen> createState() => _MenuFilterScreenState();
}

class _MenuFilterScreenState extends State<MenuFilterScreen> {
  final List<KTCheckboxValue> _selectedProviders = [];
  KTRadioValue? _selectedBrand;
  KTRadioValue? _selectedBranch;

  @override
  void initState() {
    _selectedProviders.addAll(widget.initData?.providers ?? []);
    _selectedBrand = widget.initData?.brand;
    _selectedBranch = widget.initData?.branch;
    super.initState();
  }

  void _applyFilter() {
    final providers = _selectedProviders.where((element) => element.isSelected ?? false).toList();
    MenuFilteredData? appliedFilter;
    if (providers.isEmpty && _selectedBrand == null && _selectedBranch == null) {
      appliedFilter = null;
    } else {
      appliedFilter = MenuFilteredData(brand: _selectedBrand, branch: _selectedBranch, providers: providers);
    }
    widget.onApplyFilterCallback(appliedFilter);
    Navigator.pop(context);
  }

  void _clearAll() {
    _selectedProviders.clear();
    _selectedBranch = null;
    _selectedBrand = null;
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
                  SingleBrandFilter(
                    initialValue: _selectedBrand,
                    onChangedCallback: (selectedBrand) {
                      _selectedBrand = selectedBrand;
                    },
                  ),
                  Divider(color: AppColors.grey, thickness: 8.rh),
                  if (UserPermissionManager().isBizOwner())
                    SingleBranchFilter(
                      initialValue: _selectedBranch,
                      onChangedCallback: (selectedBranch) {
                        _selectedBranch = selectedBranch;
                      },
                    ),
                  if (UserPermissionManager().isBizOwner()) Divider(color: AppColors.grey, thickness: 8.rh),
                  MultipleProviderFilter(
                    initialSelectedValues: _selectedProviders,
                    onChangedCallback: (selectedBrands) {
                      _selectedProviders.clear();
                      _selectedProviders.addAll(selectedBrands);
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
