import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/filter_by_brands_view.dart';
import 'package:klikit/resources/values.dart';

import '../../domain/entities/brand.dart';

class MenuMgtBody extends StatelessWidget {
  final List<MenuBrand> brands;

  const MenuMgtBody({Key? key, required this.brands}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s20.rw,
        vertical: AppSize.s20.rh,
      ),
      child: Column(
        children: [
          FilterByBrandsView(
            brands: brands,
            onChanged: (brand) {},
          ),
        ],
      ),
    );
  }
}
