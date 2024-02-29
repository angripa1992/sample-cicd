import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/widgets/filter/apply_filter_button.dart';
import 'package:klikit/core/widgets/filter/filter_app_bar.dart';
import 'package:klikit/core/widgets/filter/multiple_provider_filter.dart';
import 'package:klikit/modules/common/entities/branch.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/values.dart';

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
  Brand? _selectedBrand;
  Branch? _selectedBranch;

  @override
  void initState() {
    _selectedProviders.addAll(widget.initData?.providers ?? []);
    _selectedBranch = widget.initData?.branch;
    _selectedBrand = widget.initData?.brand;
    super.initState();
  }

  void _applyFilter() {
    final providers = _selectedProviders.where((element) => element.isSelected ?? false).toList();
    final appliedFilter = MenuFilteredData(brand: _selectedBrand, branch: _selectedBranch, providers: providers);
    widget.onApplyFilterCallback(appliedFilter);
    Navigator.pop(context);
  }

  void _clearAll() {
    _selectedProviders.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterAppBar(clearAll: _clearAll),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppSize.s8.verticalSpacer(),
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
          ApplyFilterButton(applyFilter: _applyFilter),
        ],
      ),
    );
  }
}
