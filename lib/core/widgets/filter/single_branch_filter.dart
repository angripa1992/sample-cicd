import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/widgets/kt_radio_group.dart';
import 'package:klikit/modules/common/entities/branch.dart';

import '../../../app/di.dart';
import '../../../modules/common/business_information_provider.dart';
import '../../../modules/common/entities/brand.dart';
import '../../../resources/colors.dart';
import 'custom_expansion_tile.dart';

class SingleBranchFilter extends StatefulWidget {
  final KTRadioValue? initialValue;
  final Function(KTRadioValue) onChangedCallback;

  const SingleBranchFilter({
    super.key,
    required this.initialValue,
    required this.onChangedCallback,
  });

  @override
  State<SingleBranchFilter> createState() => _SingleBranchFilterState();
}

class _SingleBranchFilterState extends State<SingleBranchFilter> {
  KTRadioValue? _selectedBranch;

  void _setInitialValue() {
    _selectedBranch = widget.initialValue;
  }

  List<KTRadioValue> _brandFilterItem(List<Branch> branches) {
    return branches.map((branch) {
      return KTRadioValue(branch.id, branch.title);
    }).toList();
  }

  @override
  void initState() {
    _setInitialValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SingleBranchFilter oldWidget) {
    _setInitialValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'Branch',
      trailingIcon: Icons.add,
      expandedTrailingIcon: Icons.remove,
      color: AppColors.black,
      expandedColor: AppColors.black,
      initiallyExpanded: true,
      child: FutureBuilder<List<Branch>>(
        future: getIt.get<BusinessInformationProvider>().fetchBranches(),
        builder: (_, snap) {
          if (snap.hasData && snap.data != null) {
            return KTRadioGroup(
              values: _brandFilterItem(snap.data!),
              initiallySelectedButtonID: _selectedBranch?.id,
              onChangedCallback: (selectedValue) {
                _selectedBranch = selectedValue;
                widget.onChangedCallback(_selectedBranch!);
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
    );
  }
}
