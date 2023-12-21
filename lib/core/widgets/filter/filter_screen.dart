import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/colors.dart';

import '../../../resources/styles.dart';
import '../kt_checkbox_group.dart';
import '../kt_radio_group.dart';
import 'custom_expansion_tile.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late int _currentlySelectedDateType;

  @override
  void initState() {
    _currentlySelectedDateType = widget.initiallySelectedButtonID;
    super.initState();
  }

  List<KTRadioValue> _dateFilterItems() {
    return [
      KTRadioValue(DateType.today, 'Today'),
      KTRadioValue(DateType.yesterday, 'Yesterday'),
      KTRadioValue(DateType.lastWeek, 'Last Week'),
      KTRadioValue(DateType.lastMonth, 'Last Month'),
      KTRadioValue(DateType.custom, 'Custom'),
    ];
  }

  List<KTCheckboxValue> _brandFilterItem(List<Brand> brands) {
    return brands.map((brand) {
      return KTCheckboxValue(brand.id, brand.title, logo: brand.logo);
    }).toList();
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
                  CustomExpansionTile(
                    title: 'Date',
                    trailingIcon: Icons.add,
                    expandedTrailingIcon: Icons.remove,
                    color: AppColors.black,
                    expandedColor: AppColors.black,
                    initiallyExpanded: true,
                    child: KTRadioGroup(
                      initiallySelectedButtonID: DateType.today,
                      values: _dateFilterItems(),
                      onChangedCallback: (selectedID) {},
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
                            onChangedCallback: (modifiedValue) {
                              modifiedValue.forEach((element) {
                                print(element.toString());
                              });
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  Divider(color: AppColors.grey, thickness: 8.rh),
                  CustomExpansionTile(
                    title: 'Branches',
                    trailingIcon: Icons.add,
                    expandedTrailingIcon: Icons.remove,
                    color: AppColors.black,
                    initiallyExpanded: true,
                    expandedColor: AppColors.black,
                    child: Text('Child'),
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
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
