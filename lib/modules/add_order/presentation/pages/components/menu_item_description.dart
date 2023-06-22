import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/items.dart';
import '../../../utils/order_price_provider.dart';
import 'modifier/quantity_selector.dart';

class MenuItemDescription extends StatefulWidget {
  final MenuItems items;
  final Function(int) addToCart;

  const MenuItemDescription({
    Key? key,
    required this.items,
    required this.addToCart,
  }) : super(key: key);

  @override
  State<MenuItemDescription> createState() => _MenuItemDescriptionState();
}

class _MenuItemDescriptionState extends State<MenuItemDescription> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: AppSize.s36.rw,
          child: Divider(
            color: AppColors.lightGrey,
            height: AppSize.s24.rh,
            thickness: AppSize.s2.rh,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: AppSize.s16.rw),
                child: SizedBox(
                  height: AppSize.s120.rh,
                  width: AppSize.s150.rw,
                  child: CachedNetworkImage(
                    imageUrl: ImageUrlProvider.getUrl(widget.items.image),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.s24.rh),
                        child: CircularProgressIndicator(
                            strokeWidth: AppSize.s2.rSp),
                      ),
                    ),
                    errorWidget: (context, url, error) => Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSize.s24.rh),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.placeholder,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s16.rw,
                    vertical: AppSize.s8.rh,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.items.title,
                          style: getBoldTextStyle(
                            fontSize: AppFontSize.s17.rSp,
                            color: AppColors.balticSea,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSize.s16.rSp),
                            color: AppColors.purpleBlue,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.s10.rw,
                              vertical: AppSize.s4.rh,
                            ),
                            child: Text(
                              OrderPriceProvider.klikitItemPrice(
                                  widget.items.prices),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.s14.rSp,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          widget.items.description,
                          style: getRegularTextStyle(
                            fontSize: AppFontSize.s14.rSp,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: AppSize.s1.rh),
          padding: EdgeInsets.symmetric(
              horizontal: AppSize.s12.rw, vertical: AppSize.s8.rh),
          decoration: BoxDecoration(
            color: AppColors.whiteSmoke,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
            child: Row(
              children: [
                QuantitySelector(
                  quantity: _quantity,
                  onQuantityChanged: (quantity) {
                    _quantity = quantity;
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    widget.addToCart(_quantity);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.purpleBlue,
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.s12.rh,
                        horizontal: AppSize.s16.rw,
                      ),
                      child: Text(
                        AppStrings.add_to_cart.tr(),
                        style: getRegularTextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
