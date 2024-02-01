import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../menu/domain/entities/menu/menu_item.dart';

class ItemDescriptionView extends StatelessWidget {
  final MenuCategoryItem item;

  const ItemDescriptionView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 12.rh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KTNetworkImage(
            imageUrl: item.image,
            height: 150.rh,
            boxShape: BoxShape.rectangle,
            boxFit: BoxFit.cover,
            borderRadius: BorderRadius.circular(16.rSp),
            imageBorderWidth: 0,
          ),
          SizedBox(height: 10.rh),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: mediumTextStyle(fontSize: 16.rSp, color: AppColors.neutralB500),
                ),
              ),
              SizedBox(width: 16.rw),
              Text(
                PriceCalculator.formatPrice(
                  price: item.klikitPrice().advancePrice(CartManager().orderType),
                  code: item.klikitPrice().currencyCode,
                  symbol: item.klikitPrice().currencySymbol,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.neutralB500,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.rSp,
                ),
              ),
            ],
          ),
          if(item.description.isNotEmpty) SizedBox(height: 10.rh),
          Text(
            item.description,
            style: regularTextStyle(
              fontSize: 14.rSp,
              color: AppColors.neutralB100,
            ),
          ),
        ],
      ),
    );
  }
}
