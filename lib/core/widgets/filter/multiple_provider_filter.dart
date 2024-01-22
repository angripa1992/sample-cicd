import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/common/entities/provider.dart';
import 'package:klikit/resources/strings.dart';

import '../../../app/di.dart';
import '../../../modules/common/business_information_provider.dart';
import '../../../resources/colors.dart';
import '../kt_checkbox_group.dart';
import 'custom_expansion_tile.dart';

class MultipleProviderFilter extends StatefulWidget {
  final List<KTCheckboxValue>? initialSelectedValues;
  final Function(List<KTCheckboxValue>) onChangedCallback;

  const MultipleProviderFilter({
    super.key,
    this.initialSelectedValues,
    required this.onChangedCallback,
  });

  @override
  State<MultipleProviderFilter> createState() => _MultipleProviderFilterState();
}

class _MultipleProviderFilterState extends State<MultipleProviderFilter> {
  final List<KTCheckboxValue> _selectedProviders = [];

  List<KTCheckboxValue> _brandFilterItem(List<Provider> providers) {
    return providers.map((provider) {
      final alreadySelectedOrNull = _selectedProviders.firstWhereOrNull((element) => element.id == provider.id);
      return KTCheckboxValue(
        provider.id,
        provider.title,
        logo: provider.logo,
        isSelected: alreadySelectedOrNull?.isSelected ?? false,
      );
    }).toList();
  }

  void _setInitValue() {
    _selectedProviders.clear();
    _selectedProviders.addAll(widget.initialSelectedValues ?? []);
  }

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MultipleProviderFilter oldWidget) {
    _setInitValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: AppStrings.providers.tr(),
      trailingIcon: Icons.add,
      expandedTrailingIcon: Icons.remove,
      color: AppColors.black,
      expandedColor: AppColors.black,
      initiallyExpanded: true,
      child: FutureBuilder<List<Provider>>(
        future: getIt.get<BusinessInformationProvider>().fetchProviders(),
        builder: (_, snap) {
          if (snap.hasData && snap.data != null) {
            return KTCheckboxGroup(
              values: _brandFilterItem(snap.data!),
              onChangedCallback: (modifiedValues) {
                _selectedProviders.clear();
                _selectedProviders.addAll(modifiedValues);
                widget.onChangedCallback(_selectedProviders);
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
