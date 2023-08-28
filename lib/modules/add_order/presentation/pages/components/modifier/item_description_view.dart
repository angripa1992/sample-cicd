import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../core/provider/image_url_provider.dart';
import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/assets.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/menu/menu_item.dart';

class ItemDescriptionView extends StatelessWidget {
  final MenuCategoryItem item;

  const ItemDescriptionView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSize.s8.rSp),
          bottomRight: Radius.circular(AppSize.s8.rSp),
        ),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s12.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: AppSize.s80.rh,
              width: AppSize.s80.rw,
              child: CachedNetworkImage(
                imageUrl: ImageUrlProvider.getUrl(item.image),
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
                    child:
                        CircularProgressIndicator(strokeWidth: AppSize.s2.rSp),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: AppSize.s16.rw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: boldTextStyle(
                        fontSize: AppFontSize.s17.rSp,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppSize.s4.rh),
                    Text(
                      item.description,
                      style: regularTextStyle(
                        fontSize: AppFontSize.s14.rSp,
                        color: AppColors.black,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                          color: AppColors.primary,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.s10.rw,
                            vertical: AppSize.s4.rh,
                          ),
                          child: Text(
                            PriceCalculator.formatPrice(
                              price: item.klikitPrice().price,
                              code: item.klikitPrice().currencyCode,
                              symbol: item.klikitPrice().currencySymbol,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
