import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/presentation/components/filter/select_all_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/di.dart';
import '../../../../widgets/app_button.dart';
import '../../../provider/order_information_provider.dart';
import '../../filter_subject.dart';
import 'brand_filter_item.dart';

class BrandFilter extends StatefulWidget {
  final FilterSubject filterSubject;

  const BrandFilter({Key? key, required this.filterSubject}) : super(key: key);

  @override
  State<BrandFilter> createState() => _BrandFilterState();
}

class _BrandFilterState extends State<BrandFilter> {
  final _controller = ExpandedTileController(isExpanded: false);
  final _orderInfoProvider = getIt.get<OrderInformationProvider>();
  final List<Brand> _brands = [];
  final List<Brand> _applyingBrands = [];
  String _title = AppStrings.brand.tr();

  @override
  void initState() {
    _controller.addListener(_onToggle);
    super.initState();
  }

  void _onToggle() {
    String title = AppStrings.brand.tr();
    if (!_controller.isExpanded) {
      final selectedAggregator =
          _applyingBrands.where((element) => element.isChecked).toList().length;
      if (selectedAggregator > 0) {
        title = '$selectedAggregator  ${AppStrings.brands_selected.tr()}';
      }
    }
    setState(() {
      _title = title;
    });
  }

  void _changeSelectedStatus(bool isChecked, Brand brand) async {
    brand.isChecked = isChecked;
    _applyingBrands.removeWhere((element) => element.id == brand.id);
    _applyingBrands.add(brand);
  }

  void _apply() async {
    for (var brand in _applyingBrands) {
      _brands[_brands.indexWhere((element) => element.id == brand.id)] = brand;
    }
    widget.filterSubject.applyBrandsFilter(
      await _orderInfoProvider.extractBrandsIds(
        _brands.where((element) => element.isChecked).toList(),
      ),
    );
    _controller.toggle();
  }

  void _copyDataToLocalVariable(List<Brand> brands) async {
    _applyingBrands.clear();
    if (_brands.isEmpty) {
      for (var brand in brands) {
        _brands.add(brand.copy());
      }
      widget.filterSubject
          .setBrands(await _orderInfoProvider.extractBrandsIds(_brands));
    }
    _applyingBrands.addAll(_brands);
  }

  void _changeAllSelection(bool isChecked) {
    _applyingBrands.clear();
    for (var brand in _brands) {
      brand.isChecked = isChecked;
    }
    _applyingBrands.addAll(_brands);
  }

  bool _isAllSelected() {
    bool allSelected = true;
    for (var brand in _brands) {
      if (!brand.isChecked) {
        allSelected = false;
        break;
      }
    }
    return allSelected;
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.greyLight,
        headerPadding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s8.rh,
        ),
        headerSplashColor: AppColors.primaryLight,
        contentBackgroundColor: AppColors.greyLight,
        contentPadding: EdgeInsets.zero,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.black,
      ),
      trailingRotation: 180,
      title: Text(
        _title,
        style: regularTextStyle(
          color: AppColors.black,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      content: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: FutureBuilder<List<Brand>>(
          future: _orderInfoProvider.fetchBrands(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _copyDataToLocalVariable(snapshot.data!);
              return StatefulBuilder(
                builder: (_, setState) {
                  return Column(
                    children: [
                      SelectAllView(
                        isAllSelected: _isAllSelected(),
                        onSelectChange: (isAllSelected) {
                          _changeAllSelection(isAllSelected);
                          setState(() {});
                        },
                      ),
                      const Divider(),
                      ListView.separated(
                        itemCount: _brands.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return BrandFilterItem(
                            brand: _brands[index],
                            onChanged: (isChecked, brand) {
                              _changeSelectedStatus(isChecked, brand);
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                      AppButton(
                        onTap: () {
                          _apply();
                        },
                        text: AppStrings.apply.tr(),
                        color: AppColors.primary,
                        icon: Icons.search,
                      ),
                    ],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      controller: _controller,
    );
  }
}
