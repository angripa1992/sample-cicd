import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/utils/modifier_manager.dart';

import '../../../../../../core/provider/image_url_provider.dart';
import '../../../../../../resources/assets.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../modifier/quantity_selector.dart';

class CartItemView extends StatelessWidget {
  final VoidCallback onEdit;
  final AddToCartItem cartItem;

  const CartItemView({
    Key? key,
    required this.cartItem,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
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
                        Text(
                          '${cartItem.itemPrice.symbol} ${cartItem.itemPrice.price}',
                          style: TextStyle(
                            color: AppColors.balticSea,
                            fontSize: AppFontSize.s14.rSp,
                            fontWeight: FontWeight.w500,
                          ),
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
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: cartItem.modifiers.isEmpty
                      ? AppColors.dustyGreay
                      : AppColors.purpleBlue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s20.rSp),
                ),
              ),
              onPressed: cartItem.modifiers.isEmpty ? null : onEdit,
              child: Text(
                'Edit',
                style: getRegularTextStyle(
                  color: cartItem.modifiers.isEmpty
                      ? AppColors.dustyGreay
                      : AppColors.purpleBlue,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
            SizedBox(width: AppSize.s8.rw),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.purpleBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s20.rSp),
                ),
              ),
              onPressed: () {},
              child: Text(
                '+ Discount',
                style: getRegularTextStyle(
                  color: AppColors.purpleBlue,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
            SizedBox(width: AppSize.s8.rw),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.red,
              ),
            ),
            const Spacer(),
            QuantitySelector(
              quantity: cartItem.quantity,
              onQuantityChanged: (quantity) {},
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
