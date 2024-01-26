import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';

import '../../../app/di.dart';
import '../../../modules/common/business_information_provider.dart';
import '../../../modules/common/entities/branch.dart';
import '../../../resources/colors.dart';
import '../kt_checkbox_group.dart';
import 'custom_expansion_tile.dart';

class MultipleBranchFilter extends StatefulWidget {
  final List<KTCheckboxValue>? initialSelectedValues;
  final Function(List<KTCheckboxValue>) onChangedCallback;

  const MultipleBranchFilter({
    super.key,
    this.initialSelectedValues,
    required this.onChangedCallback,
  });

  @override
  State<MultipleBranchFilter> createState() => _MultipleBranchFilterState();
}

class _MultipleBranchFilterState extends State<MultipleBranchFilter> {
  final List<KTCheckboxValue> _selectedBranches = [];

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

  void _setInitValue() {
    _selectedBranches.clear();
    _selectedBranches.addAll(widget.initialSelectedValues ?? []);
  }

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MultipleBranchFilter oldWidget) {
    _setInitValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'Branches',
      trailingIcon: Icons.add,
      expandedTrailingIcon: Icons.remove,
      color: AppColors.black,
      expandedColor: AppColors.black,
      initiallyExpanded: true,
      child: FutureBuilder<List<Branch>>(
        future: getIt.get<BusinessInformationProvider>().fetchBranches(),
        builder: (_, snap) {
          if (snap.hasData && snap.data != null) {
            return KTCheckboxGroup(
              values: _branchFilterItem(snap.data!),
              onChangedCallback: (modifiedValues) {
                _selectedBranches.clear();
                _selectedBranches.addAll(modifiedValues);
                widget.onChangedCallback(_selectedBranches);
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ).setVisibilityWithSpace(startSpace: 8, endSpace: 8, direction: Axis.vertical);
        },
      ),
    );
  }
}
