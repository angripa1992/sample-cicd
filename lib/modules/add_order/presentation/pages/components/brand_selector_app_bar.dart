import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dropdown/select_brand_dropdown.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/brand.dart';
import 'cart_badge.dart';

class BrandSelectorAppBar extends StatelessWidget {
  final MenuBrand? initialBrand;
  final List<MenuBrand> brands;
  final Function(MenuBrand) onChanged;
  final VoidCallback onBack;
  final VoidCallback onCartTap;

  const BrandSelectorAppBar({
    Key? key,
    required this.brands,
    required this.onChanged,
    required this.onBack,
    required this.onCartTap,
    required this.initialBrand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.purpleBlue,
              ),
            ),
            Expanded(
              child: Center(
                child: SelectBrandDropDown(
                  brands: brands,
                  onChanged: onChanged,
                  initialBrand: initialBrand,
                ),
              ),
            ),
            CartBadge(
              onCartTap: onCartTap,
            ),
          ],
        ),
      ),
    );
  }
}
