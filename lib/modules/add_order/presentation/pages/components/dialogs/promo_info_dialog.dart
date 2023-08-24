import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/add_order/data/models/applied_promo.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

void showPromoInfoDialog(BuildContext context, AppliedPromo promo) {
  showDialog(
    context: context,
    builder: (dContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s16.rSp),
          ),
        ),
        content: PromoInfoView(promo: promo),
      );
    },
  );
}

class PromoInfoView extends StatelessWidget {
  final AppliedPromo promo;

  const PromoInfoView({Key? key, required this.promo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencySymbol = CartManager().currency().symbol;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        SizedBox(height: AppSize.s8.rh),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _itemInfo('Value Type', promo.valueType ?? ''),
            _itemInfo('Max Value', '$currencySymbol ${promo.maxDiscount}'),
          ],
        ),
        SizedBox(height: AppSize.s16.rh),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _itemInfo('Min Value', '$currencySymbol ${promo.minOrderAmount}'),
            _itemInfo('Promo End', DateTimeProvider.dateTime(promo.endTime!)),
          ],
        ),
      ],
    );
  }

  Widget _itemInfo(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Text(
          value,
          style: regularTextStyle(
            color: AppColors.greyDarker,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
      ],
    );
  }
}
