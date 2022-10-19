import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/presentation/order/components/brand_filter_item.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/di.dart';
import '../../../../../../core/provider/order_information_provider.dart';
import '../../observer/filter_subject.dart';

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

  void _changeSelectedStatus(bool isChecked, Brand value) async {
    final brand = value.copyWith(isChecked: isChecked);
    _brands[_brands.indexWhere((element) => element.id == brand.id)] = brand;
    widget.filterSubject.applyBrandsFilter(
      await _orderInfoProvider.extractBrandsIds(
        _brands.where((element) => element.isChecked).toList(),
      ),
    );
  }

  void _copyDataToLocalVariable(List<Brand> brands) async{
    if (_brands.isEmpty) {
      for (var brand in brands) {
        _brands.add(brand.copy());
      }
      widget.filterSubject.setBrands(await _orderInfoProvider.extractBrandsIds(_brands));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.lightVioletTwo,
        headerPadding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
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
        'Filter by brand',
        style: getRegularTextStyle(
          color: AppColors.purpleBlue,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      content: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: FutureBuilder<Brands>(
          future: _orderInfoProvider.getBrands(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _copyDataToLocalVariable(snapshot.data!.brands);
              return ListView.builder(
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
