import 'package:flutter/material.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dropdown/select_brand_dropdown.dart';


import '../../../../menu/domain/entities/brand.dart';

class BrandSelectorAppBar extends StatelessWidget {
  final List<MenuBrand> brands;
  final Function(MenuBrand) onChanged;

  const BrandSelectorAppBar({
    Key? key,
    required this.brands,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SelectBrandDropDown(brands: brands, onChanged: onChanged),
            ),
          ),
          Icon(Icons.add_shopping_cart),
        ],
      ),
    );
  }
}
