import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../core/provider/image_url_provider.dart';
import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/assets.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../../../../domain/entities/billing_response.dart';
import '../../../../utils/modifier_manager.dart';

class DeleteItemDialogView extends StatelessWidget {
  final AddToCartItem cartItem;
  final VoidCallback onDelete;
  final ItemBill itemBill;

  const DeleteItemDialogView({
    Key? key,
    required this.cartItem,
    required this.onDelete,
    required this.itemBill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final haveDiscount = itemBill.discountedItemPrice != itemBill.itemPrice;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppStrings.want_to_delete_item_msg,
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s24.rh),
          child: Row(
            children: [
              SizedBox(
                height: AppSize.s48.rh,
                width: AppSize.s48.rw,
                child: CachedNetworkImage(
                  imageUrl: ImageUrlProvider.getUrl(cartItem.item.image),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  progressIndicatorBuilder: (_, __, ___) => Center(
                    child: SizedBox(
                      height: AppSize.s16.rh,
                      width: AppSize.s16.rw,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: SvgPicture.asset(
                      AppImages.placeholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.s16.rw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${cartItem.quantity}x ${cartItem.item.title}',
                            style: getMediumTextStyle(
                              color: AppColors.purpleBlue,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.s16.rw),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (haveDiscount)
                              Text(
                                PriceCalculator.formatPrice(
                                  price: itemBill.discountedItemPrice * cartItem.quantity,
                                  currencySymbol: cartItem.itemPrice.symbol,
                                  code: cartItem.itemPrice.code,
                                ),
                                style: TextStyle(
                                  color: AppColors.balticSea,
                                  fontSize: AppFontSize.s14.rSp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            Text(
                              PriceCalculator.formatPrice(
                                price: itemBill.itemPrice * cartItem.quantity,
                                currencySymbol: cartItem.itemPrice.symbol,
                                code: cartItem.itemPrice.code,
                              ),
                              style: TextStyle(
                                color: haveDiscount
                                    ? AppColors.red
                                    : AppColors.balticSea,
                                fontSize: AppFontSize.s14.rSp,
                                fontWeight: FontWeight.w500,
                                decoration: haveDiscount
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.s8.rh),
                    FutureBuilder<String>(
                      future: ModifierManager()
                          .allCsvModifiersName(cartItem.modifiers),
                      builder: (context, snapShot) {
                        if (snapShot.hasData) {
                          return Text(snapShot.data!);
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.water, // Background color
              ),
              child: Text(
                AppStrings.cancel.tr(),
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
                ),
              ),
            ),
            SizedBox(width: AppSize.s24.rw),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red, // Background color
              ),
              child: Text(
                AppStrings.delete.tr(),
                style: getMediumTextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DeleteAllDialogView extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteAllDialogView({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppStrings.want_to_delete_all_item_msg,
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        SizedBox(height: AppSize.s16.rh),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.water, // Background color
              ),
              child: Text(
                AppStrings.cancel.tr(),
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
                ),
              ),
            ),
            SizedBox(width: AppSize.s24.rw),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red, // Background color
              ),
              child: Text(
                AppStrings.delete.tr(),
                style: getMediumTextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
