import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/widgets/app_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/di.dart';
import '../../../../../../core/provider/order_information_provider.dart';
import '../../observer/filter_subject.dart';
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

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.lightVioletTwo,
        headerPadding: EdgeInsets.symmetric(
          horizontal: AppSize.s12.rw,
          vertical: AppSize.s8.rh,
        ),
        headerSplashColor: AppColors.lightViolet,
        contentBackgroundColor: AppColors.pearl,
        contentPadding: EdgeInsets.zero,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.purpleBlue,
      ),
      trailingRotation: 180,
      title: Text(
        AppStrings.filter_by_brand.tr(),
        style: getRegularTextStyle(
          color: AppColors.purpleBlue,
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
              return Column(
                children: [
                  ListView.builder(
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
                  ),
                  AppButton(
                    enable: true,
                    onTap: () {
                      _apply();
                    },
                    text: AppStrings.apply.tr(),
                    enableColor: AppColors.purpleBlue,
                    verticalPadding: AppSize.s6.rh,
                    icon: Icons.search,
                    textSize: AppFontSize.s14,
                    enableBorderColor: AppColors.purpleBlue,
                  ),
                ],
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
