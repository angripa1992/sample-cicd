import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/widgets/kt_radio_group.dart';
import 'package:klikit/resources/strings.dart';

import '../../../app/di.dart';
import '../../../modules/common/business_information_provider.dart';
import '../../../modules/common/entities/brand.dart';
import '../../../resources/colors.dart';
import 'custom_expansion_tile.dart';

class SingleBrandFilter extends StatefulWidget {
  final KTRadioValue? initialValue;
  final Function(KTRadioValue) onChangedCallback;

  const SingleBrandFilter({
    super.key,
    required this.initialValue,
    required this.onChangedCallback,
  });

  @override
  State<SingleBrandFilter> createState() => _SingleBrandFilterState();
}

class _SingleBrandFilterState extends State<SingleBrandFilter> {
  KTRadioValue? _selectedBrand;

  void _setInitialValue() {
    _selectedBrand = widget.initialValue;
  }

  List<KTRadioValue> _brandFilterItem(List<Brand> brands) {
    return brands.map((brand) {
      return KTRadioValue(brand.id, brand.title, logo: brand.logo);
    }).toList();
  }

  @override
  void initState() {
    _setInitialValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SingleBrandFilter oldWidget) {
    _setInitialValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: AppStrings.brand.tr(),
      trailingIcon: Icons.add,
      expandedTrailingIcon: Icons.remove,
      color: AppColors.black,
      expandedColor: AppColors.black,
      initiallyExpanded: true,
      child: FutureBuilder<List<Brand>>(
        future: getIt.get<BusinessInformationProvider>().fetchBrands(),
        builder: (_, snap) {
          if (snap.hasData && snap.data != null) {
            return KTRadioGroup(
              values: _brandFilterItem(snap.data!),
              initiallySelectedButtonID: _selectedBrand?.id,
              onChangedCallback: (selectedValue) {
                _selectedBrand = selectedValue;
                widget.onChangedCallback(_selectedBrand!);
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
