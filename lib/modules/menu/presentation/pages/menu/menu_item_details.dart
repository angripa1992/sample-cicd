import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../app/constants.dart';
import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/menu/menu_item.dart';
import '../../../domain/entities/menu/menu_out_of_stock.dart';
import 'menu_snooze_view.dart';
import 'menu_switch_view.dart';

class MenuItemDetails extends StatefulWidget {
  final MenuCategoryItem menuCategoryItem;
  final bool parentEnabled;
  final Function(MenuOutOfStock) onChanged;
  final int brandID;
  final int providerID;
  final int brandId;

  const MenuItemDetails({
    Key? key,
    required this.menuCategoryItem,
    required this.parentEnabled,
    required this.onChanged,
    required this.brandID,
    required this.providerID,
    required this.brandId,
  }) : super(key: key);

  @override
  State<MenuItemDetails> createState() => _MenuItemDetailsState();
}

class _MenuItemDetailsState extends State<MenuItemDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    ImageUrlProvider.getUrl(widget.menuCategoryItem.image),
                imageBuilder: (context, imageProvider) => Container(
                  height: AppSize.s180.rh,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSize.s14.rSp),
                    ),
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
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: AppSize.s8.rh,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
                    child: Text(
                      widget.menuCategoryItem.title,
                      style: regularTextStyle(
                        fontSize: AppFontSize.s16.rSp,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                MenuSnoozeView(
                  menuCategoryItem: widget.menuCategoryItem,
                  brandId: widget.brandId,
                  providerId: widget.providerID,
                  borderRadius: AppSize.s16.rSp,
                  width: AppSize.s100.rw,
                  bgColor: AppColors.dustyOrange.withOpacity(0.1),
                  parentEnabled: widget.parentEnabled,
                  iconPath: AppIcons.edit,
                  onChanged: (oos) {
                    widget.onChanged(oos);
                    setState(() {
                      widget.menuCategoryItem.outOfStock = oos;
                    });
                  },
                ),
                MenuSwitchView(
                  id: widget.menuCategoryItem.id,
                  brandId: widget.brandID,
                  providerId: widget.providerID,
                  type: MenuType.ITEM,
                  enabled: widget.menuCategoryItem.outOfStock.available,
                  parentEnabled: widget.parentEnabled,
                  willShowBg: false,
                  onItemChanged: (oos) {
                    widget.onChanged(oos);
                    setState(() {
                      widget.menuCategoryItem.outOfStock = oos;
                    });
                  },
                  onMenuChanged: (enabled) {},
                ),
              ],
            ),
          ),
          if (widget.menuCategoryItem.outOfStock.menuSnooze.endTime.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                bottom: AppSize.s8.rh,
                right: AppSize.s10.rw,
                left: AppSize.s10.rw,
              ),
              child: Text(
                '(${AppStrings.out_of_stock_till.tr()} ${DateTimeProvider.parseSnoozeEndTime(widget.menuCategoryItem.outOfStock.menuSnooze.endTime)})',
                textAlign: TextAlign.right,
                style: mediumTextStyle(
                  color: AppColors.warmRed,
                  fontSize: AppFontSize.s12.rSp,
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
                child: Text(
                  widget.menuCategoryItem.description,
                  textAlign: TextAlign.start,
                  style: regularTextStyle(
                      fontSize: AppFontSize.s14.rSp, color: AppColors.coolGrey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
