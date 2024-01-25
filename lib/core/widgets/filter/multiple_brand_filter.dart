import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/resources/strings.dart';

import '../../../app/di.dart';
import '../../../modules/common/business_information_provider.dart';
import '../../../modules/common/entities/brand.dart';
import '../../../resources/colors.dart';
import '../kt_checkbox_group.dart';
import 'custom_expansion_tile.dart';

class MultipleBrandFilter extends StatefulWidget {
  final List<KTCheckboxValue>? initialSelectedValues;
  final Function(List<KTCheckboxValue>) onChangedCallback;

  const MultipleBrandFilter({
    super.key,
    this.initialSelectedValues,
    required this.onChangedCallback,
  });

  @override
  State<MultipleBrandFilter> createState() => _MultipleBrandFilterState();
}

class _MultipleBrandFilterState extends State<MultipleBrandFilter> {
  final List<KTCheckboxValue> _selectedBrands = [];

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

  void _setInitValue() {
    _selectedBrands.clear();
    _selectedBrands.addAll(widget.initialSelectedValues ?? []);
  }

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MultipleBrandFilter oldWidget) {
    _setInitValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: AppStrings.brands.tr(),
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
                widget.onChangedCallback(_selectedBrands);
              },
            );
          }
          return Center(
            child: CircularProgress(primaryColor: AppColors.primary),
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
