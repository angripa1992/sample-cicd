import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../core/provider/image_url_provider.dart';
import '../../../../../../resources/assets.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../../../../utils/modifier_manager.dart';

class DeleteItemDialogView extends StatelessWidget {
  final AddToCartItem cartItem;
  final VoidCallback onDelete;

  const DeleteItemDialogView(
      {Key? key, required this.cartItem, required this.onDelete})
      : super(key: key);

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
                'Are you sure you want to delete the following item?',
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
                'Cancel',
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
                'Delete',
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
                'Are you sure you want to delete the all items?',
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
                'Cancel',
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
                'Delete',
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
