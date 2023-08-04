import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../core/utils/price_calculator.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/menu/menu_item.dart';
import 'modifier/quantity_selector.dart';
import 'modifier/speacial_instruction.dart';

class MenuItemDescription extends StatefulWidget {
  final MenuCategoryItem menuCategoryItem;
  final Function(int, String) addToCart;

  const MenuItemDescription({
    Key? key,
    required this.menuCategoryItem,
    required this.addToCart,
  }) : super(key: key);

  @override
  State<MenuItemDescription> createState() => _MenuItemDescriptionState();
}

class _MenuItemDescriptionState extends State<MenuItemDescription> {
  final _textController = TextEditingController();
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final itemPrice = widget.menuCategoryItem.klikitPrice();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.clear,
                color: AppColors.bluewood,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppSize.s8.rw,
                vertical: AppSize.s12.rh,
              ),
              padding: EdgeInsets.only(
                left: AppSize.s16.rw,
                right: AppSize.s16.rw,
                top: AppSize.s8.rh,
                bottom: AppSize.s16.rh,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSize.s16.rh,
                      ),
                      child: SizedBox(
                        height: AppSize.s120.rh,
                        width: AppSize.s150.rw,
                        child: CachedNetworkImage(
                          imageUrl: ImageUrlProvider.getUrl(
                              widget.menuCategoryItem.image),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.s16.rSp),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSize.s24.rh),
                              child: CircularProgressIndicator(
                                  strokeWidth: AppSize.s2.rSp),
                            ),
                          ),
                          errorWidget: (context, url, error) => Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: AppSize.s24.rh),
                            child: Center(
                              child: SvgPicture.asset(
                                AppImages.placeholder,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.menuCategoryItem.title,
                    style: boldTextStyle(
                      fontSize: AppFontSize.s17.rSp,
                      color: AppColors.balticSea,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                      color: AppColors.purpleBlue,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.s10.rw,
                        vertical: AppSize.s4.rh,
                      ),
                      child: Text(
                        PriceCalculator.formatPrice(
                          price: itemPrice.price,
                          code: itemPrice.currencyCode,
                          symbol: itemPrice.currencySymbol,
                        ),
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
                    widget.menuCategoryItem.description,
                    style: regularTextStyle(
                      fontSize: AppFontSize.s14.rSp,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SpecialInstructionField(controller: _textController),
        Container(
          margin: EdgeInsets.only(top: AppSize.s8.rh),
          padding: EdgeInsets.symmetric(
              horizontal: AppSize.s12.rw, vertical: AppSize.s8.rh),
          decoration: BoxDecoration(
            color: AppColors.white,
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
                    widget.addToCart(_quantity, _textController.text);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.purpleBlue,
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.s8.rh,
                        horizontal: AppSize.s16.rw,
                      ),
                      child: Text(
                        AppStrings.add_to_cart.tr(),
                        style: mediumTextStyle(
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
