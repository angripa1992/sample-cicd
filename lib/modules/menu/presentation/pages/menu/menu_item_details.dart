import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/provider.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/provider_advanced_price.dart';

import '../../../../../app/constants.dart';
import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../core/utils/price_calculator.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/menu/menu_item.dart';
import '../../../domain/entities/menu/menu_out_of_stock.dart';
import 'advanced_pricing_tags.dart';
import 'menu_snooze_view.dart';
import 'menu_switch_view.dart';

class MenuItemDetails extends StatefulWidget {
  final MenuCategoryItem menuCategoryItem;
  final bool parentEnabled;
  final Function(MenuOutOfStock) onMenuItemSnoozeChanged;
  final Function(bool) onMenuEnabledChanged;
  final int brandID;
  final int providerID;
  final int brandId;

  const MenuItemDetails({
    Key? key,
    required this.menuCategoryItem,
    required this.parentEnabled,
    required this.onMenuItemSnoozeChanged,
    required this.onMenuEnabledChanged,
    required this.brandID,
    required this.providerID,
    required this.brandId,
  }) : super(key: key);

  @override
  State<MenuItemDetails> createState() => _MenuItemDetailsState();
}

class _MenuItemDetailsState extends State<MenuItemDetails> {
  void _onEnabledChanged(bool enabled) {
    widget.onMenuEnabledChanged(enabled);
    setState(() {
      widget.menuCategoryItem.outOfStock.available = enabled;
      widget.menuCategoryItem.enabled = enabled;
    });
  }

  void _onItemSnoozeChanged(MenuOutOfStock oos) {
    widget.onMenuItemSnoozeChanged(oos);
    setState(() {
      widget.menuCategoryItem.outOfStock = oos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildIconButton(context),
            buildBody(),
          ],
        ),
      ),
    );
  }

  Expanded buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildCachedNetworkImage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.menuCategoryItem.title.trim(),
                    style: mediumTextStyle(
                      fontSize: AppFontSize.s16.rSp,
                      color: AppColors.black,
                    ),
                  ),
                ),
                MenuSnoozeView(
                  menuCategoryItem: widget.menuCategoryItem,
                  brandId: widget.brandId,
                  providerId: widget.providerID,
                  parentEnabled: widget.parentEnabled,
                  onMenuItemSnoozeChanged: _onItemSnoozeChanged,
                  onMenuEnabledChanged: _onEnabledChanged,
                ),
                MenuSwitchView(
                  menuVersion: widget.menuCategoryItem.menuVersion,
                  id: widget.menuCategoryItem.id,
                  brandId: widget.brandID,
                  providerId: widget.providerID,
                  type: MenuType.ITEM,
                  enabled: widget.menuCategoryItem.enabled,
                  parentEnabled: widget.parentEnabled,
                  willShowBg: false,
                  onMenuEnableChanged: _onEnabledChanged,
                ),
              ],
            ),
            if (widget.menuCategoryItem.outOfStock.menuSnooze.endTime.isNotEmpty)
              Text(
                '(${AppStrings.out_of_stock_till.tr()} ${DateTimeProvider.parseSnoozeEndTime(widget.menuCategoryItem.outOfStock.menuSnooze.endTime)})',
                style: mediumTextStyle(
                  color: AppColors.redDark,
                  fontSize: AppFontSize.s12.rSp,
                ),
              ),
            Visibility(
              visible: widget.menuCategoryItem.description.isNotEmpty,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
                child: Text(
                  widget.menuCategoryItem.description,
                  textAlign: TextAlign.start,
                  style: regularTextStyle(
                    fontSize: AppFontSize.s14.rSp,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            Text(
              'Price ${PriceCalculator.formatPrice(
                price: widget.menuCategoryItem.klikitPrice().price,
                symbol: widget.menuCategoryItem.klikitPrice().currencySymbol,
                code: widget.menuCategoryItem.klikitPrice().currencyCode,
              )}',
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            SizedBox(height: AppSize.s8.rh),
            MenuAdvancedPriceTags(
              menuCategoryItem: widget.menuCategoryItem,
              providerID: ProviderID.KLIKIT,
            ),
            SizedBox(height: AppSize.s8.rh),
            FutureBuilder<Provider>(
              future: getIt.get<BusinessInformationProvider>().findProviderById(ProviderID.GRAB_FOOD),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ProviderAdvancePrice(
                    provider: snapshot.data!,
                    menuCategoryItem: widget.menuCategoryItem,
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.remove,
        color: AppColors.greyDarker,
        size: AppSize.s32.rSp,
      ),
    );
  }

  CachedNetworkImage buildCachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: ImageUrlProvider.getUrl(widget.menuCategoryItem.image),
      imageBuilder: (context, imageProvider) => Container(
        height: AppSize.s180.rh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp)),
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
          child: CircularProgressIndicator(strokeWidth: AppSize.s2.rSp),
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
    );
  }
}
